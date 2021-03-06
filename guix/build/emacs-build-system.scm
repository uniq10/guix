;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2016 David Thompson <davet@gnu.org>
;;; Copyright © 2016 Alex Kost <alezost@gmail.com>
;;; Copyright © 2018 Maxim Cournoyer <maxim.cournoyer@gmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (guix build emacs-build-system)
  #:use-module ((guix build gnu-build-system) #:prefix gnu:)
  #:use-module (guix build utils)
  #:use-module (guix build emacs-utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 match)
  #:export (%standard-phases
            %default-include
            %default-exclude
            emacs-build))

;; Commentary:
;;
;; Builder-side code of the build procedure for ELPA Emacs packages.
;;
;; Code:

;; Directory suffix where we install ELPA packages.  We avoid ".../elpa" as
;; Emacs expects to find the ELPA repository 'archive-contents' file and the
;; archive signature.
(define %legacy-install-suffix "/share/emacs/site-lisp")
(define %install-suffix (string-append %legacy-install-suffix "/guix.d"))

;; These are the default inclusion/exclusion regexps for the install phase.
(define %default-include '("^[^/]*\\.el$" "^[^/]*\\.info$" "^doc/.*\\.info$"))
(define %default-exclude '("^\\.dir-locals\\.el$" "-pkg\\.el$"
                           "^[^/]*tests?\\.el$"))

(define gnu:unpack (assoc-ref gnu:%standard-phases 'unpack))

(define (store-file->elisp-source-file file)
  "Convert FILE, a store file name for an Emacs Lisp source file, into a file
name that has been stripped of the hash and version number."
  (let ((suffix ".el"))
    (let-values (((name version)
                  (package-name->name+version
                   (basename
                    (strip-store-file-name file) suffix))))
      (string-append name suffix))))

(define* (unpack #:key source #:allow-other-keys)
  "Unpack SOURCE into the build directory.  SOURCE may be a compressed
archive, a directory, or an Emacs Lisp file."
  (if (string-suffix? ".el" source)
      (begin
        (mkdir "source")
        (chdir "source")
        (copy-file source (store-file->elisp-source-file source))
        #t)
      (gnu:unpack #:source source)))

(define* (set-emacs-load-path #:key source inputs #:allow-other-keys)
  (define (inputs->directories inputs)
    "Extract the directory part from INPUTS."
    (match inputs
      (((names . directories) ...) directories)))

  (define (input-directory->el-directory input-directory)
    "Return the correct Emacs Lisp directory in INPUT-DIRECTORY or #f, if there
is no Emacs Lisp directory."
    (let ((legacy-elisp-directory (string-append input-directory %legacy-install-suffix))
          (guix-elisp-directory
           (string-append
            input-directory %install-suffix "/"
            (store-directory->elpa-name-version input-directory))))
      (cond
       ((file-exists? guix-elisp-directory) guix-elisp-directory)
       ((file-exists? legacy-elisp-directory) legacy-elisp-directory)
       (else #f))))

  (define (input-directories->el-directories input-directories)
    "Return the list of Emacs Lisp directories in INPUT-DIRECTORIES."
    (filter-map input-directory->el-directory input-directories))

  "Set the EMACSLOADPATH environment variable so that dependencies are found."
  (let* ((source-directory (getcwd))
         (input-elisp-directories (input-directories->el-directories
                                   (inputs->directories inputs)))
         (emacs-load-path-value
          (string-join
           (append input-elisp-directories (list source-directory))
           ":" 'suffix)))
    (setenv "EMACSLOADPATH" emacs-load-path-value)
    (format #t "environment variable `EMACSLOADPATH' set to ~a\n"
            emacs-load-path-value)))

(define* (build #:key outputs inputs #:allow-other-keys)
  "Compile .el files."
  (let* ((emacs (string-append (assoc-ref inputs "emacs") "/bin/emacs"))
         (out (assoc-ref outputs "out"))
         (elpa-name-ver (store-directory->elpa-name-version out))
         (el-dir (string-append out %install-suffix "/" elpa-name-ver)))
    (setenv "SHELL" "sh")
    (parameterize ((%emacs emacs))
      (emacs-byte-compile-directory el-dir))))

(define* (patch-el-files #:key outputs #:allow-other-keys)
  "Substitute the absolute \"/bin/\" directory with the right location in the
store in '.el' files."

  (define (file-contains-nul-char? file)
    (call-with-input-file file
      (lambda (in)
        (let loop ((line (read-line in 'concat)))
          (cond
           ((eof-object? line) #f)
           ((string-index line #\nul) #t)
           (else (loop (read-line in 'concat))))))
      #:binary #t))

  (let* ((out (assoc-ref outputs "out"))
         (elpa-name-ver (store-directory->elpa-name-version out))
         (el-dir (string-append out %install-suffix "/" elpa-name-ver))

         ;; (ice-9 regex) uses libc's regexp routines, which cannot deal with
         ;; strings containing NULs.  Filter out such files.  TODO: Remove
         ;; this workaround when <https://bugs.gnu.org/30116> is fixed.
         (el-files (remove file-contains-nul-char?
                           (find-files (getcwd) "\\.el$"))))
    (define (substitute-program-names)
      (substitute* el-files
        (("\"/bin/([^.]\\S*)\"" _ cmd-name)
         (let ((cmd (which cmd-name)))
           (unless cmd
             (error "patch-el-files: unable to locate " cmd-name))
           (string-append "\"" cmd "\"")))))

    (with-directory-excursion el-dir
      ;; Some old '.el' files (e.g., tex-buf.el in AUCTeX) are still
      ;; ISO-8859-1-encoded.
      (unless (false-if-exception (substitute-program-names))
        (with-fluids ((%default-port-encoding "ISO-8859-1"))
          (substitute-program-names))))
    #t))

(define* (check #:key tests? (test-command '("make" "check"))
                (parallel-tests? #t) #:allow-other-keys)
  "Run the tests by invoking TEST-COMMAND.

When TEST-COMMAND uses make and PARALLEL-TESTS is #t, the tests are run in
parallel. PARALLEL-TESTS? is ignored when using a non-make TEST-COMMAND."
  (match-let (((test-program . args) test-command))
    (let ((using-make? (string=? test-program "make")))
      (if tests?
          (apply invoke test-program
                 `(,@args
                   ,@(if (and using-make? parallel-tests?)
                         `("-j" ,(number->string (parallel-job-count)))
                         '())))
          (begin
            (format #t "test suite not run~%")
            #t)))))

(define* (install #:key outputs
                  (include %default-include)
                  (exclude %default-exclude)
                  #:allow-other-keys)
  "Install the package contents."

  (define source (getcwd))

  (define* (install-file? file stat #:key verbose?)
    (let* ((stripped-file (string-trim
                           (string-drop file (string-length source)) #\/)))
      (define (match-stripped-file action regex)
        (let ((result (string-match regex stripped-file)))
          (when (and result verbose?)
                (format #t "info: ~A ~A as it matches \"~A\"\n"
                        stripped-file action regex))
          result))

      (when verbose?
            (format #t "info: considering installing ~A\n" stripped-file))

      (and (any (cut match-stripped-file "included" <>) include)
           (not (any (cut match-stripped-file "excluded" <>) exclude)))))

  (let* ((out (assoc-ref outputs "out"))
         (elpa-name-ver (store-directory->elpa-name-version out))
         (target-directory (string-append out %install-suffix "/" elpa-name-ver))
         (files-to-install (find-files source install-file?)))
    (cond
     ((not (null? files-to-install))
      (for-each
       (lambda (file)
         (let* ((stripped-file (string-drop file (string-length source)))
                (target-file (string-append target-directory stripped-file)))
           (format #t "`~a' -> `~a'~%" file target-file)
           (install-file file (dirname target-file))))
       files-to-install)
      #t)
     (else
      (format #t "error: No files found to install.\n")
      (find-files source (lambda (file stat)
                           (install-file? file stat #:verbose? #t)))
      #f))))

(define* (move-doc #:key outputs #:allow-other-keys)
  "Move info files from the ELPA package directory to the info directory."
  (let* ((out (assoc-ref outputs "out"))
         (elpa-name-ver (store-directory->elpa-name-version out))
         (el-dir (string-append out %install-suffix "/" elpa-name-ver))
         (name-ver (strip-store-file-name out))
         (info-dir (string-append out "/share/info/"))
         (info-files (find-files el-dir "\\.info$")))
    (unless (null? info-files)
      (mkdir-p info-dir)
      (with-directory-excursion el-dir
        (when (file-exists? "dir") (delete-file "dir"))
        (for-each (lambda (f)
                    (copy-file f (string-append info-dir "/" (basename f)))
                    (delete-file f))
                  info-files)))
    #t))

(define* (make-autoloads #:key outputs inputs #:allow-other-keys)
  "Generate the autoloads file."
  (let* ((emacs (string-append (assoc-ref inputs "emacs") "/bin/emacs"))
         (out (assoc-ref outputs "out"))
         (elpa-name-ver (store-directory->elpa-name-version out))
         (elpa-name (package-name->name+version elpa-name-ver))
         (el-dir (string-append out %install-suffix "/" elpa-name-ver)))
    (parameterize ((%emacs emacs))
      (emacs-generate-autoloads elpa-name el-dir))))

(define (emacs-package? name)
  "Check if NAME correspond to the name of an Emacs package."
  (string-prefix? "emacs-" name))

(define (package-name-version->elpa-name-version name-ver)
  "Convert the Guix package NAME-VER to the corresponding ELPA name-version
format.  Essentially drop the prefix used in Guix."
  (if (emacs-package? name-ver)  ; checks for "emacs-" prefix
      (string-drop name-ver (string-length "emacs-"))
      name-ver))

(define (store-directory->elpa-name-version store-dir)
  "Given a store directory STORE-DIR return the part of the basename after the
second hyphen.  This corresponds to 'name-version' as used in ELPA packages."
  ((compose package-name-version->elpa-name-version
            strip-store-file-name)
   store-dir))

(define %standard-phases
  (modify-phases gnu:%standard-phases
    (replace 'unpack unpack)
    (add-after 'unpack 'set-emacs-load-path set-emacs-load-path)
    (delete 'configure)
    ;; Move the build phase after install: the .el files are byte compiled
    ;; directly in the store.
    (delete 'build)
    (replace 'check check)
    (replace 'install install)
    (add-after 'install 'build build)
    (add-after 'install 'make-autoloads make-autoloads)
    (add-after 'make-autoloads 'patch-el-files patch-el-files)
    (add-after 'make-autoloads 'move-doc move-doc)))

(define* (emacs-build #:key inputs (phases %standard-phases)
                      #:allow-other-keys #:rest args)
  "Build the given Emacs package, applying all of PHASES in order."
  (apply gnu:gnu-build
         #:inputs inputs #:phases phases
         args))

;;; emacs-build-system.scm ends here
