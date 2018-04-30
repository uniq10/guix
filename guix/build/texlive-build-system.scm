;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Ricardo Wurmus <rekado@elephly.net>
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

(define-module (guix build texlive-build-system)
  #:use-module ((guix build gnu-build-system) #:prefix gnu:)
  #:use-module (guix build utils)
  #:use-module (guix build union)
  #:use-module (ice-9 match)
  #:use-module (ice-9 ftw)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:export (%standard-phases
            texlive-build))

;; Commentary:
;;
;; Builder-side code of the standard build procedure for TeX Live packages.
;;
;; Code:

(define (compile-with-latex format file)
  (zero? (system* format
                  "-interaction=batchmode"
                  "-output-directory=build"
                  (string-append "&" format)
                  file)))

(define* (configure #:key inputs #:allow-other-keys)
  (let* ((out       (string-append (getcwd) "/.texlive-union"))
         (texmf.cnf (string-append out "/share/texmf-dist/web2c/texmf.cnf")))
    ;; Build a modifiable union of all inputs (but exclude bash)
    (match inputs
      (((names . directories) ...)
       (union-build out (filter directory-exists? directories)
                    #:create-all-directories? #t
                    #:log-port (%make-void-port "w"))))

    ;; The configuration file "texmf.cnf" is provided by the
    ;; "texlive-bin" package.  We take it and override only the
    ;; setting for TEXMFROOT and TEXMF.  This file won't be consulted
    ;; by default, though, so we still need to set TEXMFCNF.
    (substitute* texmf.cnf
      (("^TEXMFROOT = .*")
       (string-append "TEXMFROOT = " out "/share\n"))
      (("^TEXMF = .*")
       "TEXMF = $TEXMFROOT/share/texmf-dist\n"))
    (setenv "TEXMFCNF" (dirname texmf.cnf))
    (setenv "TEXMF" (string-append out "/share/texmf-dist")))
  (mkdir "build")
  #t)

(define* (build #:key inputs build-targets tex-format #:allow-other-keys)
  (every (cut compile-with-latex tex-format <>)
         (if build-targets build-targets
             (scandir "." (cut string-suffix? ".ins" <>)))))

(define* (install #:key outputs tex-directory #:allow-other-keys)
  (let* ((out (assoc-ref outputs "out"))
         (target (string-append
                  out "/share/texmf-dist/tex/" tex-directory)))
    (mkdir-p target)
    (for-each delete-file (find-files "." "\\.(log|aux)$"))
    (for-each (cut install-file <> target)
              (find-files "build" ".*"))
    #t))

(define %standard-phases
  (modify-phases gnu:%standard-phases
    (replace 'configure configure)
    (replace 'build build)
    (delete 'check)
    (replace 'install install)))

(define* (texlive-build #:key inputs (phases %standard-phases)
                        #:allow-other-keys #:rest args)
  "Build the given TeX Live package, applying all of PHASES in order."
  (apply gnu:gnu-build #:inputs inputs #:phases phases args))

;;; texlive-build-system.scm ends here
