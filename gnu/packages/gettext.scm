;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012 Nikita Karetnikov <nikita@karetnikov.org>
;;; Copyright © 2014 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015, 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Alex Kost <alezost@gmail.com>
;;; Copyright © 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2017 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2017 Eric Bavier <bavier@member.fsf.org>
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

(define-module (gnu packages gettext)
  #:use-module ((guix licenses) #:select (gpl2+ gpl3+))
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system perl)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages xml)
  #:use-module (guix utils))

(define-public gettext-minimal
  (package
    (name "gettext-minimal")
    (version "0.19.8.1")
    (source (origin
             (method url-fetch)
             (uri (string-append "mirror://gnu/gettext/gettext-"
                                 version ".tar.gz"))
             (sha256
              (base32
               "0hsw28f9q9xaggjlsdp2qmbp2rbd1mp0njzan2ld9kiqwkq2m57z"))
             (modules '((guix build utils)))
             (snippet
              '(begin
                ;; The gnulib test-lock test is prone to writer starvation
                ;; with our glibc@2.25, which prefers readers, so disable it.
                ;; The gnulib commit b20e8afb0b2 should fix this once
                ;; incorporated here.
                 (substitute* "gettext-runtime/tests/Makefile.in"
                   (("TESTS = test-lock\\$\\(EXEEXT\\)") "TESTS ="))
                 (substitute* "gettext-tools/gnulib-tests/Makefile.in"
                  (("test-lock\\$\\(EXEEXT\\) ") ""))
                 #t))))
    (build-system gnu-build-system)
    (outputs '("out"
               "doc"))                            ;8 MiB of HTML
    (inputs
     `(("expat" ,expat)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
        (add-before 'check 'patch-tests
         (lambda* (#:key inputs #:allow-other-keys)
           (let* ((bash (which "sh")))
             ;; Some of the files we're patching are
             ;; ISO-8859-1-encoded, so choose it as the default
             ;; encoding so the byte encoding is preserved.
             (with-fluids ((%default-port-encoding #f))
               (substitute*
                   (find-files "gettext-tools/tests"
                               "^(lang-sh|msg(exec|filter)-[0-9])")
                 (("#![[:blank:]]/bin/sh")
                  (format #f "#!~a" bash)))

               (substitute* (cons "gettext-tools/src/msginit.c"
                                  (find-files "gettext-tools/gnulib-tests"
                                              "posix_spawn"))
                 (("/bin/sh")
                  bash))

               (substitute* "gettext-tools/src/project-id"
                 (("/bin/pwd")
                  "pwd"))))))
        (add-before 'configure 'link-expat
         (lambda _
           ;; Gettext defaults to opening expat via dlopen on
           ;; "Linux".  Change to link directly.
           (substitute* "gettext-tools/configure"
             (("LIBEXPAT=\"-ldl\"") "LIBEXPAT=\"-ldl -lexpat\"")
             (("LTLIBEXPAT=\"-ldl\"") "LTLIBEXPAT=\"-ldl -lexpat\"")))))

       ;; When tests fail, we want to know the details.
       #:make-flags '("VERBOSE=yes")))
    (home-page "https://www.gnu.org/software/gettext/")
    (synopsis
     "Tools and documentation for translation (used to build other packages)")
    (description
     "GNU Gettext is a package providing a framework for translating the
textual output of programs into multiple languages.  It provides translators
with the means to create message catalogs, and a runtime library to load
translated messages from the catalogs.  Nearly all GNU packages use Gettext.")
    (license gpl3+)))                             ;some files are under GPLv2+

;; Use that name to avoid clashes with Guile's 'gettext' procedure.
;;
;; We used to resort to #:renamer on the user side, but that prevented
;; circular dependencies involving (gnu packages gettext).  This is because
;; 'resolve-interface' (as of Guile 2.0.9) iterates eagerly over the used
;; module when there's a #:renamer, and that module may be empty at that point
;; in case or circular dependencies.
(define-public gnu-gettext
  (package
    (inherit gettext-minimal)
    (name "gettext")
    (arguments
     (substitute-keyword-arguments (package-arguments gettext-minimal)
       ((#:phases phases)
        `(modify-phases ,phases
           (add-after 'install 'add-emacs-autoloads
             (lambda* (#:key outputs #:allow-other-keys)
               ;; Make 'po-mode' and other things available by default.
               (with-directory-excursion
                   (string-append (assoc-ref outputs "out")
                                  "/share/emacs/site-lisp")
                 (symlink "start-po.el" "gettext-autoloads.el")
                 #t)))))))
    (native-inputs `(("emacs" ,emacs-minimal))) ; for Emacs tools
    (synopsis "Tools and documentation for translation")))

(define-public po4a
  (package
    (name "po4a")
    (version "0.47")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://alioth.debian.org/frs/download.php"
                                  "/file/4142/po4a-" version ".tar.gz"))
              (sha256
               (base32
                "01vm0750aq0h2lphrflv3wq9gz7y0py8frglfpacn58ivyvy242h"))))
    (build-system perl-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'set-search-path
           (lambda _
             ;; Work around "dotless @INC" build failure.
             (setenv "PERL5LIB"
                     (string-append (getcwd) ":"
                                    (getenv "PERL5LIB")))
             #t))
         ;; FIXME: One test fails as we don't have SGMLS.pm
         (add-before 'check 'disable-sgml-test
          (lambda _
            (delete-file "t/20-sgml.t")
            #t))
         (add-after 'unpack 'fix-builder
          (lambda* (#:key inputs outputs #:allow-other-keys)
            (substitute* "Po4aBuilder.pm"
              ;; By default it tries to install into perl's manpath.
              (("my \\$mandir = .*$")
               (string-append "my $mandir = \"" (assoc-ref outputs "out")
                              "/share/man\";\n")))
            #t))
         (add-after 'install 'wrap-programs
          (lambda* (#:key outputs #:allow-other-keys)
            ;; Make sure all executables in "bin" find the Perl modules
            ;; provided by this package at runtime.
            (let* ((out  (assoc-ref outputs "out"))
                   (bin  (string-append out "/bin/"))
                   (path (string-append out "/lib/perl5/site_perl")))
              (for-each (lambda (file)
                          (wrap-program file
                            `("PERL5LIB" ":" prefix (,path))))
                        (find-files bin "\\.*$"))
              #t)))
         (add-before 'reset-gzip-timestamps 'make-compressed-files-writable
           (lambda* (#:key outputs #:allow-other-keys)
             (for-each make-file-writable
                       (find-files (string-append (assoc-ref outputs "out")
                                                  "/share/man")
                                   ".*\\.gz$"))
             #t)))))
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("perl-module-build" ,perl-module-build)
       ("docbook-xsl" ,docbook-xsl)
       ("docbook-xml" ,docbook-xml) ;for tests
       ("texlive" ,texlive-tiny) ;for tests
       ("libxml2" ,libxml2)
       ("xsltproc" ,libxslt)))
    (home-page "https://po4a.org/")
    (synopsis "Scripts to ease maintenance of translations")
    (description
     "The po4a (PO for anything) project goal is to ease translations (and
more interestingly, the maintenance of translations) using gettext tools on
areas where they were not expected like documentation.")
    (license gpl2+)))
