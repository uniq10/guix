;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 José Miguel Sánchez García <jmi2k@openmailbox.org>
;;; Copyright © 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
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

(define-module (gnu packages nim)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public nim
  (package
    (name "nim")
    (version "0.17.2")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "https://nim-lang.org/download/"
                          name "-" version ".tar.xz"))
      (sha256
       (base32
        "1gc2xk3ygmz9y4pm75pligssgw995a7gvnfpy445fjpw4d81pzxa"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; No tests.
       #:phases
         (modify-phases %standard-phases
           (delete 'configure)          ; no configure script
           (add-after 'unpack 'patch-installer
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 (substitute* "install.sh"
                   (("1/nim") "1"))
                 #t)))
           (add-after 'patch-source-shebangs 'patch-more-shebangs
             (lambda _
               (substitute* (append '("tests/stdlib/tosprocterminate.nim"
                                      "lib/pure/osproc.nim")
                                    (find-files "c_code" "stdlib_osproc.c"))
                 (("/bin/sh") (which "sh")))
               #t))
           (replace 'build
             (lambda _
               (invoke "sh" "build.sh")
               #t))
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 (invoke "./install.sh" out)
                 #t))))))
    (home-page "https://nim-lang.org")
    (synopsis "Statically-typed, imperative programming language")
    (description "Nim (formerly known as Nimrod) is a statically-typed,
imperative programming language that tries to give the programmer ultimate power
without compromises on runtime efficiency.  This means it focuses on compile-time
mechanisms in all their various forms.")
    (license license:expat)))
