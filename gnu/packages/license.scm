;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2018 Oleg Pykhalov <go.wigust@gmail.com>
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

(define-module (gnu packages license)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system perl)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check))

;;;
;;; Please: Try to add new module packages in alphabetic order.
;;;

(define-public perl-regexp-pattern-license
  (package
    (name "perl-regexp-pattern-license")
    (version "3.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://cpan/authors/id/J/JO/JONASS/Regexp-Pattern-License-"
             "v" version ".tar.gz"))
       (sha256
        (base32
         "1479ismcgq1mx712yhw0qswb4z75spc81f9k621vfpkji0smpyk2"))))
    (build-system perl-build-system)
    (native-inputs
     `(("perl-regexp-pattern" ,perl-regexp-pattern)
       ("perl-test-exception" ,perl-test-exception)))
    (propagated-inputs
     `(("perl-strictures" ,perl-strictures-2)))
    (home-page "http://search.cpan.org/dist/Regexp-Pattern-License/")
    (synopsis "Regular expressions for legal licenses")
    (description "Regexp::Pattern::License provides a hash of regular
expression patterns related to legal software licenses.

Regexp::Pattern is a convention for organizing reusable regex patterns.")
    (license gpl3+)))

(define-public perl-string-copyright
  (package
    (name "perl-string-copyright")
    (version "0.003005")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://cpan/authors/id/J/JO/JONASS/String-Copyright-"
             version ".tar.gz"))
       (sha256
        (base32
         "12c6x4c10gr46ryc3dpwgfi6wggmgy4a1ls2hwhcpdm3wvzy5619"))))
    (build-system perl-build-system)
    (native-inputs
     `(("perl-number-range" ,perl-number-range)))
    (propagated-inputs
     `(("perl-exporter-tiny" ,perl-exporter-tiny)))
    (home-page "http://search.cpan.org/dist/String-Copyright/")
    (synopsis "Representation of text-based copyright statements")
    (description "String::Copyright Parses common styles of copyright
statements and serializes in normalized format.")
    (license gpl3+)))

(define-public perl-software-license
  (package
    (name "perl-software-license")
    (version "0.103013")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://cpan/authors/id/L/LE/LEONT/Software-License-"
             version ".tar.gz"))
       (sha256
        (base32
         "1wqgh7vdlc966amlrq0b2szz18lnrl9rfh8wlf7v0hqg74vxjh96"))))
    (build-system perl-build-system)
    (native-inputs
     `(("perl-try-tiny" ,perl-try-tiny)))
    (propagated-inputs
     `(("perl-data-section" ,perl-data-section)
       ("perl-text-template" ,perl-text-template)))
    (home-page "http://search.cpan.org/dist/Software-License/")
    (synopsis "Templated software licenses")
    (description "This package provides templated software licenses.")
    (license (package-license perl))))

(define-public licensecheck
  (package
    (name "licensecheck")
    (version "3.0.34")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://cpan/authors/id/J/JO/JONASS/App-Licensecheck-"
                    "v" version ".tar.gz"))
              (sha256
               (base32
                "0k0acybgibdqg1h6xqnba1jb0spmw7hpq0jbrs7n7gfj22wkz0vd"))))
    (build-system perl-build-system)
    (native-inputs
     `(("perl-regexp-pattern" ,perl-regexp-pattern)
       ("perl-software-license" ,perl-software-license)
       ("perl-test-requires" ,perl-test-requires)
       ("perl-test-roo" ,perl-test-roo)
       ("perl-test-script" ,perl-test-script)
       ("perl-universal-require" ,perl-universal-require)
       ("perl-number-range" ,perl-number-range)
       ("perl-sub-quote" ,perl-sub-quote)))
    (propagated-inputs
     `(("perl-getopt-long-descriptive" ,perl-getopt-long-descriptive)
       ("perl-moo" ,perl-moo-2)
       ("perl-namespace-clean" ,perl-namespace-clean)
       ("perl-path-iterator-rule" ,perl-path-iterator-rule)
       ("perl-path-tiny" ,perl-path-tiny)
       ("perl-pod-constants" ,perl-pod-constants)
       ("perl-regexp-pattern-license" ,perl-regexp-pattern-license)
       ("perl-sort-key" ,perl-sort-key)
       ("perl-strictures" ,perl-strictures-2)
       ("perl-string-copyright" ,perl-string-copyright)
       ("perl-string-escape" ,perl-string-escape)
       ("perl-try-tiny" ,perl-try-tiny)
       ("perl-module-runtime" ,perl-module-runtime)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'wrap-program
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (perllib (string-append out "/lib/perl5/site_perl/"
                                            ,(package-version perl))))
               (wrap-program (string-append out "/bin/licensecheck")
                 `("PERL5LIB" ":"
                   prefix (,(string-append perllib ":" (getenv "PERL5LIB")))))
               #t))))))
    (home-page "http://search.cpan.org/dist/App-Licensecheck/")
    (synopsis "License checker for source files")
    (description "Licensecheck attempts to determine the license that applies
to each file passed to it, by searching the start of the file for text
belonging to various licenses.")
    (license (package-license perl))))
