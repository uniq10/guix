;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2016, 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
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

(define-module (gnu packages moreutils)
  #:use-module ((guix licenses) #:prefix l:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages docbook))

(define-public moreutils
  (package
    (name "moreutils")
    (version "0.62")
    (source
     (origin
       (method url-fetch)
       (uri (list
             (string-append
              "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/"
              name "-" version ".tar.gz")
             (string-append
              "http://drabczyk.org/"
              name "-" version ".tar.gz")))
       (sha256
        (base32
         "1gc3rswr0jl0z42pbrmw2zc4gxsyp60hq8cnvrlsig1vk1s9vpwx"))))
    (build-system gnu-build-system)
    ;; For building the manual pages.
    (native-inputs
     `(("docbook-xml" ,docbook-xml-4.4)
       ("docbook-xsl" ,docbook-xsl)
       ("libxml2" ,libxml2)
       ("libxslt" ,libxslt)))
    (inputs
     `(("perl" ,perl)
       ("perl-timedate" ,perl-timedate)
       ("perl-time-duration" ,perl-time-duration)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'wrap-program
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out")))
                        (wrap-program
                            (string-append out "/bin/ts")
                          `("PERL5LIB" ":" prefix (,(getenv "PERL5LIB")))))))
         (delete 'configure))           ; no configure script
       #:make-flags
       (list (string-append "PREFIX=" (assoc-ref %outputs "out"))
             (string-append "DOCBOOKXSL="
                            (assoc-ref %build-inputs "docbook-xsl") "/xml/xsl/"
                            ,(package-name docbook-xsl) "-"
                            ,(package-version docbook-xsl))
             "CC=gcc")))
    (home-page "https://joeyh.name/code/moreutils/")
    (synopsis "Miscellaneous general-purpose command-line tools")
    (description
     "Moreutils is a collection of general-purpose command-line tools to
augment the traditional Unix toolbox.")
    (license l:gpl2+)))
