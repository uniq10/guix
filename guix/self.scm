;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017, 2018 Ludovic Courtès <ludo@gnu.org>
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

(define-module (guix self)
  #:use-module (guix config)
  #:use-module (guix i18n)
  #:use-module (guix modules)
  #:use-module (guix gexp)
  #:use-module (guix store)
  #:use-module (guix monads)
  #:use-module (guix discovery)
  #:use-module (guix packages)
  #:use-module (guix sets)
  #:use-module (guix utils)
  #:use-module (guix modules)
  #:use-module (guix build utils)
  #:use-module ((guix build compile) #:select (%lightweight-optimizations))
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (ice-9 match)
  #:export (make-config.scm
            compiled-guix
            guix-derivation
            reload-guix))


;;;
;;; Dependency handling.
;;;

(define* (false-if-wrong-guile package
                               #:optional (guile-version (effective-version)))
  "Return #f if PACKAGE depends on the \"wrong\" major version of Guile (e.g.,
2.0 instead of 2.2), otherwise return PACKAGE."
  (let ((guile (any (match-lambda
                      ((label (? package? dep) _ ...)
                       (and (string=? (package-name dep) "guile")
                            dep)))
                    (package-direct-inputs package))))
    (and (or (not guile)
             (string-prefix? guile-version
                             (package-version guile)))
         package)))

(define (package-for-guile guile-version . names)
  "Return the package with one of the given NAMES that depends on
GUILE-VERSION (\"2.0\" or \"2.2\"), or #f if none of the packages matches."
  (let loop ((names names))
    (match names
      (()
       #f)
      ((name rest ...)
       (match (specification->package name)
         (#f
          (loop rest))
         ((? package? package)
          (or (false-if-wrong-guile package guile-version)
              (loop rest))))))))

(define specification->package
  ;; Use our own variant of that procedure because that of (gnu packages)
  ;; would traverse all the .scm files, which is wasteful.
  (let ((ref (lambda (module variable)
               (module-ref (resolve-interface module) variable))))
    (match-lambda
      ("guile"      (ref '(gnu packages commencement) 'guile-final))
      ("guile-json" (ref '(gnu packages guile) 'guile-json))
      ("guile-ssh"  (ref '(gnu packages ssh)   'guile-ssh))
      ("guile-git"  (ref '(gnu packages guile) 'guile-git))
      ("libgcrypt"  (ref '(gnu packages gnupg) 'libgcrypt))
      ("zlib"       (ref '(gnu packages compression) 'zlib))
      ("gzip"       (ref '(gnu packages compression) 'gzip))
      ("bzip2"      (ref '(gnu packages compression) 'bzip2))
      ("xz"         (ref '(gnu packages compression) 'xz))
      ("guix"       (ref '(gnu packages package-management)
                         'guix-register))
      ("guile2.0-json" (ref '(gnu packages guile) 'guile2.0-json))
      ("guile2.0-ssh"  (ref '(gnu packages ssh) 'guile2.0-ssh))
      ("guile2.0-git"  (ref '(gnu packages guile) 'guile2.0-git))
      (_               #f))))                     ;no such package


;;;
;;; Derivations.
;;;

;; Node in a DAG of build tasks.  Each node maps to a derivation, but it's
;; easier to express things this way.
(define-record-type <node>
  (node name modules source dependencies compiled)
  node?
  (name          node-name)                       ;string
  (modules       node-modules)                    ;list of module names
  (source        node-source)                     ;list of source files
  (dependencies  node-dependencies)               ;list of nodes
  (compiled      node-compiled))                  ;node -> lowerable object

(define (node-fold proc init nodes)
  (let loop ((nodes nodes)
             (visited (setq))
             (result init))
    (match nodes
      (() result)
      ((head tail ...)
       (if (set-contains? visited head)
           (loop tail visited result)
           (loop tail (set-insert head visited)
                 (proc head result)))))))

(define (node-modules/recursive nodes)
  (node-fold (lambda (node modules)
               (append (node-modules node) modules))
             '()
             nodes))

(define* (closure modules #:optional (except '()))
  (source-module-closure modules
                         #:select?
                         (match-lambda
                           (('guix 'config)
                            #f)
                           ((and module
                                 (or ('guix _ ...) ('gnu _ ...)))
                            (not (member module except)))
                           (rest #f))))

(define module->import
  ;; Return a file-name/file-like object pair for the specified module and
  ;; suitable for 'imported-files'.
  (match-lambda
    ((module '=> thing)
     (let ((file (module-name->file-name module)))
       (list file thing)))
    (module
        (let ((file (module-name->file-name module)))
          (list file
                (local-file (search-path %load-path file)))))))

(define* (scheme-node name modules #:optional (dependencies '())
                      #:key (extra-modules '()) (extra-files '())
                      (extensions '())
                      parallel? guile-for-build)
  "Return a node that builds the given Scheme MODULES, and depends on
DEPENDENCIES (a list of nodes).  EXTRA-MODULES is a list of additional modules
added to the source, and EXTRA-FILES is a list of additional files.
EXTENSIONS is a set of full-blown Guile packages (e.g., 'guile-json') that
must be present in the search path."
  (let* ((modules (append extra-modules
                          (closure modules
                                   (node-modules/recursive dependencies))))
         (module-files (map module->import modules))
         (source (imported-files (string-append name "-source")
                                 (append module-files extra-files))))
    (node name modules source dependencies
          (compiled-modules name source modules
                            (map node-source dependencies)
                            (map node-compiled dependencies)
                            #:extensions extensions
                            #:parallel? parallel?
                            #:guile-for-build guile-for-build))))

(define (file-imports directory sub-directory pred)
  "List all the files matching PRED under DIRECTORY/SUB-DIRECTORY.  Return a
list of file-name/file-like objects suitable as inputs to 'imported-files'."
  (map (lambda (file)
         (list (string-drop file (+ 1 (string-length directory)))
               (local-file file #:recursive? #t)))
       (find-files (string-append directory "/" sub-directory) pred)))

(define (scheme-modules* directory sub-directory)
  "Return the list of module names found under SUB-DIRECTORY in DIRECTORY."
  (let ((prefix (string-length directory)))
    (map (lambda (file)
           (file-name->module-name (string-drop file prefix)))
         (scheme-files (string-append directory "/" sub-directory)))))

(define* (compiled-guix source #:key (version %guix-version)
                        (name (string-append "guix-" version))
                        (guile-version (effective-version))
                        (guile-for-build (guile-for-build guile-version))
                        (libgcrypt (specification->package "libgcrypt"))
                        (zlib (specification->package "zlib"))
                        (gzip (specification->package "gzip"))
                        (bzip2 (specification->package "bzip2"))
                        (xz (specification->package "xz"))
                        (guix (specification->package "guix")))
  "Return a file-like object that contains a compiled Guix."
  (define guile-json
    (package-for-guile guile-version
                       "guile-json"
                       "guile2.0-json"))

  (define guile-ssh
    (package-for-guile guile-version
                       "guile-ssh"
                       "guile2.0-ssh"))

  (define guile-git
    (package-for-guile guile-version
                       "guile-git"
                       "guile2.0-git"))


  (define dependencies
    (match (append-map (lambda (package)
                         (cons (list "x" package)
                               (package-transitive-inputs package)))
                       (list guile-git guile-json guile-ssh))
      (((labels packages _ ...) ...)
       packages)))

  (define *core-modules*
    (scheme-node "guix-core"
                 '((guix)
                   (guix monad-repl)
                   (guix packages)
                   (guix download)
                   (guix discovery)
                   (guix profiles)
                   (guix build-system gnu)
                   (guix build-system trivial)
                   (guix build profiles)
                   (guix build gnu-build-system))

                 ;; Provide a dummy (guix config) with the default version
                 ;; number, storedir, etc.  This is so that "guix-core" is the
                 ;; same across all installations and doesn't need to be
                 ;; rebuilt when the version changes, which in turn means we
                 ;; can have substitutes for it.
                 #:extra-modules
                 `(((guix config)
                    => ,(make-config.scm #:libgcrypt
                                         (specification->package
                                          "libgcrypt"))))

                 #:guile-for-build guile-for-build))

  (define *extra-modules*
    (scheme-node "guix-extra"
                 (filter-map (match-lambda
                               (('guix 'scripts _ ..1) #f)
                               (name name))
                             (scheme-modules* source "guix"))
                 (list *core-modules*)
                 #:extensions dependencies
                 #:guile-for-build guile-for-build))

  (define *package-modules*
    (scheme-node "guix-packages"
                 `((gnu packages)
                   ,@(scheme-modules* source "gnu/packages"))
                 (list *core-modules* *extra-modules*)
                 #:extensions dependencies
                 #:extra-files                    ;all the non-Scheme files
                 (file-imports source "gnu/packages"
                               (lambda (file stat)
                                 (and (eq? 'regular (stat:type stat))
                                      (not (string-suffix? ".scm" file))
                                      (not (string-suffix? ".go" file))
                                      (not (string-prefix? ".#" file))
                                      (not (string-suffix? "~" file)))))
                 #:guile-for-build guile-for-build))

  (define *system-modules*
    (scheme-node "guix-system"
                 `((gnu system)
                   (gnu services)
                   ,@(scheme-modules* source "gnu/system")
                   ,@(scheme-modules* source "gnu/services"))
                 (list *package-modules* *extra-modules* *core-modules*)
                 #:extensions dependencies
                 #:extra-files
                 (file-imports source "gnu/system/examples" (const #t))
                 #:guile-for-build
                 guile-for-build))

  (define *cli-modules*
    (scheme-node "guix-cli"
                 (scheme-modules* source "/guix/scripts")
                 (list *core-modules* *extra-modules* *package-modules*
                       *system-modules*)
                 #:extensions dependencies
                 #:guile-for-build guile-for-build))

  (define *config*
    (scheme-node "guix-config"
                 '()
                 #:extra-modules
                 `(((guix config)
                    => ,(make-config.scm #:libgcrypt libgcrypt
                                         #:zlib zlib
                                         #:gzip gzip
                                         #:bzip2 bzip2
                                         #:xz xz
                                         #:guix guix
                                         #:package-name
                                         %guix-package-name
                                         #:package-version
                                         version
                                         #:bug-report-address
                                         %guix-bug-report-address
                                         #:home-page-url
                                         %guix-home-page-url)))
                 #:guile-for-build guile-for-build))

  (directory-union name
                   (append-map (lambda (node)
                                 (list (node-source node)
                                       (node-compiled node)))

                               ;; Note: *CONFIG* comes first so that it
                               ;; overrides the (guix config) module that
                               ;; comes with *CORE-MODULES*.
                               (list *config*
                                     *cli-modules*
                                     *system-modules*
                                     *package-modules*
                                     *extra-modules*
                                     *core-modules*))

                   ;; Silently choose the first entry upon collision so that
                   ;; we choose *CONFIG*.
                   #:resolve-collision 'first

                   ;; When we do (add-to-store "utils.scm"), "utils.scm" must
                   ;; be a regular file, not a symlink.  Thus, arrange so that
                   ;; regular files appear as regular files in the final
                   ;; output.
                   #:copy? #t
                   #:quiet? #t))


;;;
;;; Generating (guix config).
;;;

(define %dependency-variables
  ;; (guix config) variables corresponding to dependencies.
  '(%libgcrypt %libz %xz %gzip %bzip2 %nix-instantiate
    %sbindir %guix-register-program))

(define %persona-variables
  ;; (guix config) variables that define Guix's persona.
  '(%guix-package-name
    %guix-version
    %guix-bug-report-address
    %guix-home-page-url))

(define %config-variables
  ;; (guix config) variables corresponding to Guix configuration (storedir,
  ;; localstatedir, etc.)
  (sort (filter pair?
                (module-map (lambda (name var)
                              (and (not (memq name %dependency-variables))
                                   (not (memq name %persona-variables))
                                   (cons name (variable-ref var))))
                            (resolve-interface '(guix config))))
        (lambda (name+value1 name+value2)
          (string<? (symbol->string (car name+value1))
                    (symbol->string (car name+value2))))))

(define* (make-config.scm #:key libgcrypt zlib gzip xz bzip2 guix
                          (package-name "GNU Guix")
                          (package-version "0")
                          (bug-report-address "bug-guix@gnu.org")
                          (home-page-url "https://gnu.org/s/guix"))

  ;; Hack so that Geiser is not confused.
  (define defmod 'define-module)

  (scheme-file "config.scm"
               #~(;; The following expressions get spliced.
                   (#$defmod (guix config)
                     #:export (%guix-package-name
                               %guix-version
                               %guix-bug-report-address
                               %guix-home-page-url
                               %sbindir
                               %guix-register-program
                               %libgcrypt
                               %libz
                               %gzip
                               %bzip2
                               %xz
                               %nix-instantiate))

                   #$@(map (match-lambda
                             ((name . value)
                              #~(define-public #$name #$value)))
                           %config-variables)

                   (define %guix-package-name #$package-name)
                   (define %guix-version #$package-version)
                   (define %guix-bug-report-address #$bug-report-address)
                   (define %guix-home-page-url #$home-page-url)

                   (define %sbindir
                     ;; This is used to define '%guix-register-program'.
                     ;; TODO: Use a derivation that builds nothing but the
                     ;; C++ part.
                     #+(and guix (file-append guix "/sbin")))

                   (define %guix-register-program
                     (or (getenv "GUIX_REGISTER")
                         (and %sbindir
                              (string-append %sbindir "/guix-register"))))

                   (define %gzip
                     #+(and gzip (file-append gzip "/bin/gzip")))
                   (define %bzip2
                     #+(and bzip2 (file-append bzip2 "/bin/bzip2")))
                   (define %xz
                     #+(and xz (file-append xz "/bin/xz")))

                   (define %libgcrypt
                     #+(and libgcrypt
                            (file-append libgcrypt "/lib/libgcrypt")))
                   (define %libz
                     #+(and zlib
                            (file-append zlib "/lib/libz")))

                   (define %nix-instantiate       ;for (guix import snix)
                     "nix-instantiate"))

               ;; Guile 2.0 *requires* the 'define-module' to be at the
               ;; top-level or it 'toplevel-ref' in the resulting .go file are
               ;; made relative to a nonexistent anonymous module.
               #:splice? #t))



;;;
;;; Building.
;;;

(define (imported-files name files)
  ;; This is a non-monadic, simplified version of 'imported-files' from (guix
  ;; gexp).
  (define build
    (with-imported-modules (source-module-closure
                            '((guix build utils)))
      #~(begin
          (use-modules (ice-9 match)
                       (guix build utils))

          (mkdir (ungexp output)) (chdir (ungexp output))
          (for-each (match-lambda
                      ((final-path store-path)
                       (mkdir-p (dirname final-path))

                       ;; Note: We need regular files to be regular files, not
                       ;; symlinks, as this makes a difference for
                       ;; 'add-to-store'.
                       (copy-file store-path final-path)))
                    '#$files))))

  ;; We're just copying files around, no need to substitute or offload it.
  (computed-file name build
                 #:options '(#:local-build? #t
                             #:substitutable? #f)))

(define* (compiled-modules name module-tree modules
                           #:optional
                           (dependencies '())
                           (dependencies-compiled '())
                           #:key
                           (extensions '())       ;full-blown Guile packages
                           parallel?
                           guile-for-build)
  ;; This is a non-monadic, enhanced version of 'compiled-file' from (guix
  ;; gexp).
  (define build
    (with-imported-modules (source-module-closure
                            '((guix build compile)
                              (guix build utils)))
      #~(begin
          (use-modules (srfi srfi-26)
                       (ice-9 match)
                       (ice-9 format)
                       (ice-9 threads)
                       (guix build compile)
                       (guix build utils))

          (define (regular? file)
            (not (member file '("." ".."))))

          (define (report-load file total completed)
            (display #\cr)
            (format #t
                    "loading...\t~5,1f% of ~d files" ;FIXME: i18n
                    (* 100. (/ completed total)) total)
            (force-output))

          (define (report-compilation file total completed)
            (display #\cr)
            (format #t "compiling...\t~5,1f% of ~d files" ;FIXME: i18n
                    (* 100. (/ completed total)) total)
            (force-output))

          (define (process-directory directory output)
            (let ((files  (find-files directory "\\.scm$"))
                  (prefix (+ 1 (string-length directory))))
              ;; Hide compilation warnings.
              (parameterize ((current-warning-port (%make-void-port "w")))
                (compile-files directory #$output
                               (map (cut string-drop <> prefix) files)
                               #:workers (parallel-job-count)
                               #:report-load report-load
                               #:report-compilation report-compilation))))

          (setvbuf (current-output-port) _IONBF)
          (setvbuf (current-error-port) _IONBF)

          (set! %load-path (cons #+module-tree %load-path))
          (set! %load-path
            (append '#+dependencies
                    (map (lambda (extension)
                           (string-append extension "/share/guile/site/"
                                          (effective-version)))
                         '#+extensions)
                    %load-path))

          (set! %load-compiled-path
            (append '#+dependencies-compiled
                    (map (lambda (extension)
                           (string-append extension "/lib/guile/"
                                          (effective-version)
                                          "/site-ccache"))
                         '#+extensions)
                    %load-compiled-path))

          ;; Load the compiler modules upfront.
          (compile #f)

          (mkdir #$output)
          (chdir #+module-tree)
          (process-directory "." #$output)
          (newline))))

  (computed-file name build
                 #:guile guile-for-build
                 #:options
                 `(#:local-build? #f              ;allow substitutes

                   ;; Don't annoy people about _IONBF deprecation.
                   #:env-vars (("GUILE_WARN_DEPRECATED" . "no")))))


;;;
;;; Building.
;;;

(define (guile-for-build version)
  "Return a derivation for Guile 2.0 or 2.2, whichever matches the currently
running Guile."
  (define canonical-package                       ;soft reference
    (module-ref (resolve-interface '(gnu packages base))
                'canonical-package))

  (match version
    ("2.2.2"
     ;; Gross hack to avoid ABI incompatibilities (see
     ;; <https://bugs.gnu.org/29570>.)
     (module-ref (resolve-interface '(gnu packages guile))
                 'guile-2.2.2))
    ("2.2"
     (canonical-package (module-ref (resolve-interface '(gnu packages guile))
                                    'guile-2.2/fixed)))
    ("2.0"
     (module-ref (resolve-interface '(gnu packages guile))
                 'guile-2.0))))

(define* (guix-derivation source version
                          #:optional (guile-version (effective-version)))
  "Return, as a monadic value, the derivation to build the Guix from SOURCE
for GUILE-VERSION.  Use VERSION as the version string."
  (define (shorten version)
    (if (and (string-every char-set:hex-digit version)
             (> (string-length version) 9))
        (string-take version 9)                   ;Git commit
        version))

  (define guile
    (guile-for-build guile-version))

  (mbegin %store-monad
    (set-guile-for-build guile)
    (lower-object (compiled-guix source
                                 #:version version
                                 #:name (string-append "guix-"
                                                       (shorten version))
                                 #:guile-version (match guile-version
                                                   ("2.2.2" "2.2")
                                                   (version version))
                                 #:guile-for-build guile))))
