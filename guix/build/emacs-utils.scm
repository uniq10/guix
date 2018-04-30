;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2014 Alex Kost <alezost@gmail.com>
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

(define-module (guix build emacs-utils)
  #:use-module (guix build utils)
  #:export (%emacs
            emacs-batch-eval
            emacs-batch-edit-file
            emacs-generate-autoloads
            emacs-byte-compile-directory
            emacs-substitute-sexps
            emacs-substitute-variables))

;;; Commentary:
;;;
;;; Tools to programmatically edit files using Emacs,
;;; e.g. to replace entire s-expressions in elisp files.
;;;
;;; Code:

(define %emacs
  ;; The `emacs' command.
  (make-parameter "emacs"))

(define (emacs-batch-eval expr)
  "Run Emacs in batch mode, and execute the elisp code EXPR."
  (invoke (%emacs) "--quick" "--batch"
          (format #f "--eval=~S" expr)))

(define (emacs-batch-edit-file file expr)
  "Load FILE in Emacs using batch mode, and execute the elisp code EXPR."
  (invoke (%emacs) "--quick" "--batch"
          (string-append "--visit=" file)
          (format #f "--eval=~S" expr)))

(define (emacs-generate-autoloads name directory)
  "Generate autoloads for Emacs package NAME placed in DIRECTORY."
  (let* ((file (string-append directory "/" name "-autoloads.el"))
         (expr `(let ((backup-inhibited t)
                      (generated-autoload-file ,file))
                  (update-directory-autoloads ,directory))))
    (emacs-batch-eval expr)))

(define* (emacs-byte-compile-directory dir)
  "Byte compile all files in DIR and its sub-directories."
  (let ((expr `(byte-recompile-directory (file-name-as-directory ,dir) 0)))
    (emacs-batch-eval expr)))

(define-syntax emacs-substitute-sexps
  (syntax-rules ()
    "Substitute the S-expression immediately following the first occurrence of
LEADING-REGEXP by the string returned by REPLACEMENT in FILE.  For example:

  (emacs-substitute-sexps \"w3m.el\"
    (\"defcustom w3m-command\"
     (string-append w3m \"/bin/w3m\"))
    (\"defvar w3m-image-viewer\"
     (string-append imagemagick \"/bin/display\")))

This replaces the default values of the `w3m-command' and `w3m-image-viewer'
variables declared in `w3m.el' with the results of the `string-append' calls
above.  Note that LEADING-REGEXP uses Emacs regexp syntax."
    ((emacs-substitute-sexps file (leading-regexp replacement) ...)
     (emacs-batch-edit-file file
       `(progn (progn (goto-char (point-min))
                      (re-search-forward ,leading-regexp)
                      (kill-sexp)
                      (insert " ")
                      (insert ,(format #f "~S" replacement)))
               ...
               (basic-save-buffer))))))

(define-syntax emacs-substitute-variables
  (syntax-rules ()
    "Substitute the default value of VARIABLE by the string returned by
REPLACEMENT in FILE.  For example:

  (emacs-substitute-variables \"w3m.el\"
    (\"w3m-command\" (string-append w3m \"/bin/w3m\"))
    (\"w3m-image-viewer\" (string-append imagemagick \"/bin/display\")))

This replaces the default values of the `w3m-command' and `w3m-image-viewer'
variables declared in `w3m.el' with the results of the `string-append' calls
above."
    ((emacs-substitute-variables file (variable replacement) ...)
     (emacs-substitute-sexps file
       ((string-append "(def[a-z]+[[:space:]\n]+" variable "\\>")
        replacement)
       ...))))

;;; emacs-utils.scm ends here
