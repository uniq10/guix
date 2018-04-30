;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015, 2016, 2017, 2018 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015, 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017 Muriithi Frederick Muriuki <fredmanglis@gmail.com>
;;; Copyright © 2017 Oleg Pykhalov <go.wigust@gmail.com>
;;; Copyright © 2017 Roel Janssen <roel@gnu.org>
;;; Copyright © 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2018 Rutger Helling <rhelling@mykolab.com>
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

(define-module (gnu packages package-management)
  #:use-module (gnu packages)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages bdw-gc)
  #:use-module (gnu packages bootstrap)          ;for 'bootstrap-guile-origin'
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cpio)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages file)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages man)
  #:use-module (gnu packages nettle)
  #:use-module (gnu packages patchutils)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1))

(define (boot-guile-uri arch)
  "Return the URI for the bootstrap Guile tarball for ARCH."
  (cond ((string=? "armhf" arch)
         (string-append "http://alpha.gnu.org/gnu/guix/bootstrap/"
                        arch "-linux"
                        "/20150101/guile-2.0.11.tar.xz"))
        ((string=? "aarch64" arch)
         (string-append "http://alpha.gnu.org/gnu/guix/bootstrap/"
                        arch "-linux/20170217/guile-2.0.14.tar.xz"))
        (else
         (string-append "http://alpha.gnu.org/gnu/guix/bootstrap/"
                        arch "-linux"
                        "/20131110/guile-2.0.9.tar.xz"))))

(define-public guix
  ;; Latest version of Guix, which may or may not correspond to a release.
  ;; Note: the 'update-guix-package.scm' script expects this definition to
  ;; start precisely like this.
  (let ((version "0.14.0")
        (commit "ab85cf7185da366da56314c53d8e43276e1cccc4")
        (revision 11))
    (package
      (name "guix")

      (version (if (zero? revision)
                   version
                   (string-append version "-"
                                  (number->string revision)
                                  "." (string-take commit 7))))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.savannah.gnu.org/r/guix.git")
                      (commit commit)))
                (sha256
                 (base32
                  "1c00yr2vgsdl3kmlbjppyws47ssahamdx88y0wg26x73px71rd19"))
                (file-name (string-append "guix-" version "-checkout"))))
      (build-system gnu-build-system)
      (arguments
       `(#:configure-flags (list
                            "--localstatedir=/var"
                            "--sysconfdir=/etc"
                            (string-append "--with-bash-completion-dir="
                                           (assoc-ref %outputs "out")
                                           "/etc/bash_completion.d")
                            (string-append "--with-libgcrypt-prefix="
                                           (assoc-ref %build-inputs
                                                      "libgcrypt"))

                            ;; Set 'DOT_USER_PROGRAM' to the empty string so
                            ;; we don't keep a reference to Graphviz, whose
                            ;; closure is pretty big (too big for the GuixSD
                            ;; installation image.)
                            "ac_cv_path_DOT_USER_PROGRAM=dot"

                            ;; To avoid problems with the length of shebangs,
                            ;; choose a fixed-width and short directory name
                            ;; for tests.
                            "ac_cv_guix_test_root=/tmp/guix-tests")
         #:parallel-tests? #f         ;work around <http://bugs.gnu.org/21097>

         #:modules ((guix build gnu-build-system)
                    (guix build utils)
                    (srfi srfi-26)
                    (ice-9 popen)
                    (ice-9 rdelim))

         #:phases (modify-phases %standard-phases
                    (add-after 'unpack 'bootstrap
                      (lambda _
                        ;; Make sure 'msgmerge' can modify the PO files.
                        (for-each (lambda (po)
                                    (chmod po #o666))
                                  (find-files "." "\\.po$"))

                        (patch-shebang "build-aux/git-version-gen")

                        (call-with-output-file ".tarball-version"
                          (lambda (port)
                            (display ,version port)))

                        (zero? (system* "sh" "bootstrap"))))
                    (add-before 'check 'copy-bootstrap-guile
                      (lambda* (#:key system inputs #:allow-other-keys)
                        ;; Copy the bootstrap guile tarball in the store used
                        ;; by the test suite.
                        (define (intern tarball)
                          (let ((base (strip-store-file-name tarball)))
                            (copy-file tarball base)
                            (invoke "./test-env" "guix" "download"
                                    (string-append "file://" (getcwd)
                                                   "/" base))
                            (delete-file base)))


                        (intern (assoc-ref inputs "boot-guile"))

                        ;; On x86_64 some tests need the i686 Guile.
                        ,@(if (and (not (%current-target-system))
                                   (string=? (%current-system)
                                             "x86_64-linux"))
                              '((intern (assoc-ref inputs "boot-guile/i686")))
                              '())
                        #t))
                    (add-after 'unpack 'disable-failing-tests
                      ;; XXX FIXME: These tests fail within the build container.
                      (lambda _
                        (substitute* "tests/syscalls.scm"
                          (("^\\(test-(assert|equal) \"(clone|setns|pivot-root)\"" all)
                           (string-append "(test-skip 1)\n" all)))
                        (substitute* "tests/containers.scm"
                          (("^\\(test-(assert|equal)" all)
                           (string-append "(test-skip 1)\n" all)))
                        (when (file-exists? "tests/guix-environment-container.sh")
                          (substitute* "tests/guix-environment-container.sh"
                            (("guix environment --version")
                             "exit 77\n")))
                        #t))
                    (add-before 'check 'set-SHELL
                      (lambda _
                        ;; 'guix environment' tests rely on 'SHELL' having a
                        ;; correct value, so set it.
                        (setenv "SHELL" (which "sh"))
                        #t))
                    (add-after 'install 'wrap-program
                      (lambda* (#:key inputs outputs #:allow-other-keys)
                        ;; Make sure the 'guix' command finds GnuTLS,
                        ;; Guile-JSON, and Guile-Git automatically.
                        (let* ((out    (assoc-ref outputs "out"))
                               (guile  (assoc-ref inputs "guile"))
                               (json   (assoc-ref inputs "guile-json"))
                               (git    (assoc-ref inputs "guile-git"))
                               (bs     (assoc-ref inputs
                                                  "guile-bytestructures"))
                               (ssh    (assoc-ref inputs "guile-ssh"))
                               (gnutls (assoc-ref inputs "gnutls"))
                               (deps   (list json gnutls git bs ssh))
                               (effective
                                (read-line
                                 (open-pipe* OPEN_READ
                                             (string-append guile "/bin/guile")
                                             "-c" "(display (effective-version))")))
                               (path   (string-join
                                        (map (cut string-append <>
                                                  "/share/guile/site/"
                                                  effective)
                                             deps)
                                        ":"))
                               (gopath (string-join
                                        (map (cut string-append <>
                                                  "/lib/guile/" effective
                                                  "/site-ccache")
                                             deps)
                                        ":")))

                          (wrap-program (string-append out "/bin/guix")
                            `("GUILE_LOAD_PATH" ":" prefix (,path))
                            `("GUILE_LOAD_COMPILED_PATH" ":" prefix (,gopath)))

                          #t))))))
      (native-inputs `(("pkg-config" ,pkg-config)

                       ;; XXX: Keep the development inputs here even though
                       ;; they're unnecessary, just so that 'guix environment
                       ;; guix' always contains them.
                       ("autoconf" ,autoconf-wrapper)
                       ("automake" ,automake)
                       ("gettext" ,gettext-minimal)
                       ("texinfo" ,texinfo)
                       ("graphviz" ,graphviz)
                       ("help2man" ,help2man)
                       ("po4a" ,po4a)))
      (inputs
       `(("bzip2" ,bzip2)
         ("gzip" ,gzip)
         ("zlib" ,zlib)                           ;for 'guix publish'

         ("sqlite" ,sqlite)
         ("libgcrypt" ,libgcrypt)
         ("guile" ,guile-2.2)

         ;; Many tests rely on the 'guile-bootstrap' package, which is why we
         ;; have it here.
         ("boot-guile" ,(bootstrap-guile-origin (%current-system)))
         ;; Some of the tests use "unshare" when it is available.
         ("util-linux" ,util-linux)
         ,@(if (and (not (%current-target-system))
                    (string=? (%current-system) "x86_64-linux"))
               `(("boot-guile/i686" ,(bootstrap-guile-origin "i686-linux")))
               '())))
      (propagated-inputs
       `(("gnutls" ,gnutls)
         ("guile-json" ,guile-json)
         ("guile-ssh" ,guile-ssh)
         ("guile-git" ,guile-git)
         ("guile-sqlite3" ,guile-sqlite3)))

      (home-page "https://www.gnu.org/software/guix/")
      (synopsis "Functional package manager for installed software packages and versions")
      (description
       "GNU Guix is a functional package manager for the GNU system, and is
also a distribution thereof.  It includes a virtual machine image.  Besides
the usual package management features, it also supports transactional
upgrades and roll-backs, per-user profiles, and much more.  It is based on
the Nix package manager.")
      (license license:gpl3+)
      (properties '((ftp-server . "alpha.gnu.org"))))))

;; Alias for backward compatibility.
(define-public guix-devel guix)

(define-public guix-register
  ;; This package is for internal consumption: it allows us to quickly build
  ;; the 'guix-register' program, which is referred to by (guix config).
  ;; TODO: Remove this hack when 'guix-register' has been superseded by Scheme
  ;; code.
  (package
    (inherit guix)
    (properties `((hidden? . #t)))
    (name "guix-register")
    (arguments
     (substitute-keyword-arguments (package-arguments guix)
       ((#:tests? #f #f)
        #f)
       ((#:phases phases '%standard-phases)
        `(modify-phases ,phases
           (replace 'build
             (lambda _
               (invoke "make" "nix/libstore/schema.sql.hh")
               (invoke "make" "-j" (number->string
                                    (parallel-job-count))
                       "guix-register")))
           (delete 'copy-bootstrap-guile)
           (replace 'install
             (lambda _
               (invoke "make" "install-sbinPROGRAMS")))
           (delete 'wrap-program)))))))

(define-public guile2.0-guix
  (package
    (inherit guix)
    (name "guile2.0-guix")
    (inputs
     `(("guile" ,guile-2.0)
       ,@(alist-delete "guile" (package-inputs guix))))
    (propagated-inputs
     `(("gnutls" ,gnutls/guile-2.0)
       ("guile-json" ,guile2.0-json)
       ("guile-ssh" ,guile2.0-ssh)
       ("guile-git" ,guile2.0-git)))))

(define (source-file? file stat)
  "Return true if FILE is likely a source file, false if it is a typical
generated file."
  (define (wrong-extension? file)
    (or (string-suffix? "~" file)
        (member (file-extension file)
                '("o" "a" "lo" "so" "go"))))

  (match (basename file)
    ((or ".git" "autom4te.cache" "configure" "Makefile" "Makefile.in" ".libs")
     #f)
    ((? wrong-extension?)
     #f)
    (_
     #t)))

(define-public current-guix
  (let* ((repository-root (canonicalize-path
                           (string-append (current-source-directory)
                                          "/../..")))
         (select? (delay (or (git-predicate repository-root)
                             source-file?))))
    (lambda ()
      "Return a package representing Guix built from the current source tree.
This works by adding the current source tree to the store (after filtering it
out) and returning a package that uses that as its 'source'."
      (package
        (inherit guix)
        (version (string-append (package-version guix) "+"))
        (source (local-file repository-root "guix-current"
                            #:recursive? #t
                            #:select? (force select?)))))))


;;;
;;; Other tools.
;;;

(define-public nix
  (package
    (name "nix")
    (version "1.11.9")
    (source (origin
             (method url-fetch)
             (uri (string-append "http://nixos.org/releases/nix/nix-"
                                 version "/nix-" version ".tar.xz"))
             (sha256
              (base32
               "1qg7qrfr60dysmyfg3ijgani71l23p1kqadhjs8kz11pgwkkx50f"))))
    (build-system gnu-build-system)
    ;; XXX: Should we pass '--with-store-dir=/gnu/store'?  But then we'd also
    ;; need '--localstatedir=/var'.  But then!  The thing would use /var/nix
    ;; instead of /var/guix.  So in the end, we do nothing special.
    (arguments
     '(#:configure-flags
       ;; Set the prefixes of Perl libraries to avoid propagation.
       (let ((perl-libdir (lambda (p)
                            (string-append
                             (assoc-ref %build-inputs p)
                             "/lib/perl5/site_perl"))))
         (list (string-append "--with-dbi="
                              (perl-libdir "perl-dbi"))
               (string-append "--with-dbd-sqlite="
                              (perl-libdir "perl-dbd-sqlite"))
               (string-append "--with-www-curl="
                              (perl-libdir "perl-www-curl"))))))
    (native-inputs `(("perl" ,perl)
                     ("pkg-config" ,pkg-config)))
    (inputs `(("curl" ,curl)
              ("openssl" ,openssl)
              ("libgc" ,libgc)
              ("sqlite" ,sqlite)
              ("bzip2" ,bzip2)
              ("perl-www-curl" ,perl-www-curl)
              ("perl-dbi" ,perl-dbi)
              ("perl-dbd-sqlite" ,perl-dbd-sqlite)))
    (home-page "https://nixos.org/nix/")
    (synopsis "The Nix package manager")
    (description
     "Nix is a purely functional package manager.  This means that it treats
packages like values in purely functional programming languages such as
Haskell—they are built by functions that don't have side-effects, and they
never change after they have been built.  Nix stores packages in the Nix
store, usually the directory /nix/store, where each package has its own unique
sub-directory.")
    (license license:lgpl2.1+)))

(define-public emacs-nix-mode
  (package
    (inherit nix)
    (name "emacs-nix-mode")
    (build-system emacs-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chdir-elisp
           ;; Elisp directory is not in root of the source.
           (lambda _
             (chdir "misc/emacs"))))))
    (synopsis "Emacs major mode for editing Nix expressions")
    (description "@code{nixos-mode} provides an Emacs major mode for editing
Nix expressions.  It supports syntax highlighting, indenting and refilling of
comments.")))

(define-public stow
  (package
    (name "stow")
    (version "2.2.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/stow/stow-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1pvky9fayms4r6fhns8jd0vavszd7d979w62vfd5n88v614pdxz2"))))
    (build-system gnu-build-system)
    (inputs
     `(("perl" ,perl)))
    (native-inputs
     `(("perl-test-simple" ,perl-test-simple)
       ("perl-test-output" ,perl-test-output)
       ("perl-capture-tiny" ,perl-capture-tiny)
       ("perl-io-stringy" ,perl-io-stringy)))
    (home-page "https://www.gnu.org/software/stow/")
    (synopsis "Managing installed software packages")
    (description
     "GNU Stow is a symlink manager.  It generates symlinks to directories
of data and makes them appear to be merged into the same directory.  It is
typically used for managing software packages installed from source, by
letting you install them apart in distinct directories and then create
symlinks to the files in a common directory such as /usr/local.")
    (license license:gpl2+)))

(define-public rpm
  (package
    (name "rpm")
    (version "4.13.0.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://ftp.rpm.org/releases/rpm-"
                                  (version-major+minor version) ".x/rpm-"
                                  version ".tar.bz2"))
              (sha256
               (base32
                "1521y4ghjns449kzpwkjn9cksh686383xnfx0linzlalqc3jqgig"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags '("--with-external-db"   ;use the system's bdb
                           "--enable-python"
                           "--without-lua")
       #:phases (modify-phases %standard-phases
                  (add-before 'configure 'set-nspr-search-path
                    (lambda* (#:key inputs #:allow-other-keys)
                      ;; nspr.pc contains the right -I flag pointing to
                      ;; 'include/nspr', but unfortunately 'configure' doesn't
                      ;; use 'pkg-config'.  Thus, augment CPATH.
                      ;; Likewise for NSS.
                      (let ((nspr (assoc-ref inputs "nspr"))
                            (nss  (assoc-ref inputs "nss")))
                        (setenv "CPATH"
                                (string-append (getenv "C_INCLUDE_PATH") ":"
                                               nspr "/include/nspr:"
                                               nss "/include/nss"))
                        (setenv "LIBRARY_PATH"
                                (string-append (getenv "LIBRARY_PATH") ":"
                                               nss "/lib/nss"))
                        #t)))
                  (add-after 'install 'fix-rpm-symlinks
                    (lambda* (#:key outputs #:allow-other-keys)
                      ;; 'make install' gets these symlinks wrong.  Fix them.
                      (let* ((out (assoc-ref outputs "out"))
                             (bin (string-append out "/bin")))
                        (with-directory-excursion bin
                          (for-each (lambda (file)
                                      (delete-file file)
                                      (symlink "rpm" file))
                                    '("rpmquery" "rpmverify"))
                          #t)))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("python" ,python-2)
       ("xz" ,xz)
       ("bdb" ,bdb)
       ("popt" ,popt)
       ("nss" ,nss)
       ("nspr" ,nspr)
       ("libarchive" ,libarchive)
       ("nettle" ,nettle)            ;XXX: actually a dependency of libarchive
       ("file" ,file)
       ("bzip2" ,bzip2)
       ("zlib" ,zlib)
       ("cpio" ,cpio)))
    (home-page "http://www.rpm.org/")
    (synopsis "The RPM Package Manager")
    (description
     "The RPM Package Manager (RPM) is a command-line driven package
management system capable of installing, uninstalling, verifying, querying,
and updating computer software packages.  Each software package consists of an
archive of files along with information about the package like its version, a
description.  There is also a library permitting developers to manage such
transactions from C or Python.")

    ;; The whole is GPLv2+; librpm itself is dual-licensed LGPLv2+ | GPLv2+.
    (license license:gpl2+)))

(define-public diffoscope
  (package
    (name "diffoscope")
    (version "93")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri name version))
              (sha256
               (base32
                "0g90nf7817jk03hzk36l3hymky4xqs50iynfld3r0in7hffly5nj"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  ;; setup.py mistakenly requires python-magic from PyPi, even
                  ;; though the Python bindings of `file` are sufficient.
                  ;; https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=815844
                  (add-after 'unpack 'dependency-on-python-magic
                    (lambda _
                      (substitute* "setup.py"
                        (("'python-magic',") ""))))
                  (add-after 'unpack 'embed-tool-references
                    (lambda* (#:key inputs #:allow-other-keys)
                      (substitute* "diffoscope/comparators/utils/compare.py"
                        (("\\['xxd',")
                         (string-append "['" (which "xxd") "',")))
                      (substitute* "diffoscope/comparators/elf.py"
                        (("@tool_required\\('readelf'\\)") "")
                        (("get_tool_name\\('readelf'\\)")
                         (string-append "'" (which "readelf") "'")))
                      (substitute* "diffoscope/comparators/directory.py"
                        (("@tool_required\\('stat'\\)") "")
                        (("@tool_required\\('getfacl'\\)") "")
                        (("\\['stat',")
                         (string-append "['" (which "stat") "',"))
                        (("\\['getfacl',")
                         (string-append "['" (which "getfacl") "',")))
                      #t))
                  (add-before 'check 'delete-failing-test
                    (lambda _
                      (delete-file "tests/test_tools.py") ;this requires /sbin to be on the path
                      #t)))))
    (inputs `(("rpm" ,rpm)                        ;for rpm-python
              ("python-file" ,python-file)
              ("python-debian" ,python-debian)
              ("python-libarchive-c" ,python-libarchive-c)
              ("python-tlsh" ,python-tlsh)
              ("acl" ,acl)                        ;for getfacl
              ("colordiff" ,colordiff)
              ("xxd" ,xxd)

              ;; Below are modules used for tests.
              ("python-pytest" ,python-pytest)
              ("python-chardet" ,python-chardet)))
    (home-page "https://diffoscope.org/")
    (synopsis "Compare files, archives, and directories in depth")
    (description
     "Diffoscope tries to get to the bottom of what makes files or directories
different.  It recursively unpacks archives of many kinds and transforms
various binary formats into more human readable forms to compare them.  It can
compare two tarballs, ISO images, or PDFs just as easily.")
    (license license:gpl3+)))

(define-public python-anaconda-client
  (package
    (name "python-anaconda-client")
    (version "1.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/Anaconda-Platform/"
                           "anaconda-client/archive/" version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1wv4wi6k5jz7rlwfgvgfdizv77x3cr1wa2aj0k1595g7fbhkjhz2"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-pyyaml" ,python-pyyaml)
       ("python-requests" ,python-requests)
       ("python-clyent" ,python-clyent)))
    (native-inputs
     `(("python-pytz" ,python-pytz)
       ("python-dateutil" ,python-dateutil)
       ("python-mock" ,python-mock)
       ("python-coverage" ,python-coverage)
       ("python-pillow" ,python-pillow)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; This is needed for some tests.
         (add-before 'check 'set-up-home
           (lambda* _ (setenv "HOME" "/tmp") #t))
         (add-before 'check 'remove-network-tests
           (lambda* _
             ;; Remove tests requiring a network connection
             (let ((network-tests '("tests/test_upload.py"
                                    "tests/test_authorizations.py"
                                    "tests/test_login.py"
                                    "tests/test_whoami.py"
                                    "utils/notebook/tests/test_data_uri.py"
                                    "utils/notebook/tests/test_base.py"
                                    "utils/notebook/tests/test_downloader.py"
                                    "inspect_package/tests/test_conda.py")))
               (with-directory-excursion "binstar_client"
                 (for-each delete-file network-tests)))
             #t)))))
    (home-page "https://github.com/Anaconda-Platform/anaconda-client")
    (synopsis "Anaconda Cloud command line client library")
    (description
     "Anaconda Cloud command line client library provides an interface to
Anaconda Cloud.  Anaconda Cloud is useful for sharing packages, notebooks and
environments.")
    (license license:bsd-3)))

(define-public python2-anaconda-client
  (package-with-python2 python-anaconda-client))

(define-public python-conda
  (package
    (name "python-conda")
    (version "4.3.16")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/conda/conda/archive/"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1jq8hyrc5npb5sf4vw6s6by4602yj8f79vzpbwdfgpkn02nfk1dv"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'build 'create-version-file
           (lambda _
             (with-output-to-file "conda/.version"
               (lambda () (display ,version)))
             #t))
         (add-before 'check 'remove-failing-tests
           (lambda _
             ;; These tests require internet/network access
             (let ((network-tests '("test_cli.py"
                                    "test_create.py"
                                    "test_export.py"
                                    "test_fetch.py"
                                    "test_history.py"
                                    "test_info.py"
                                    "test_install.py"
                                    "test_priority.py"
                                    "conda_env/test_cli.py"
                                    "conda_env/test_create.py"
                                    "conda_env/specs/test_notebook.py"
                                    "conda_env/utils/test_notebooks.py"
                                    "core/test_index.py"
                                    "core/test_repodata.py")))
               (with-directory-excursion "tests"
                 (for-each delete-file network-tests)

                 ;; FIXME: This test creates a file, then deletes it and tests
                 ;; that the file was deleted.  For some reason it fails when
                 ;; building with guix, but does not when you run it in the
                 ;; directory left when you build with the --keep-failed
                 ;; option
                 (delete-file "gateways/disk/test_delete.py")
                 #t))))
         (replace 'check
           (lambda _
             (setenv "HOME" "/tmp")
             (zero? (system* "py.test")))))))
    (native-inputs
     `(("python-ruamel.yaml" ,python-ruamel.yaml)
       ("python-requests" ,python-requests)
       ("python-pycosat" ,python-pycosat)
       ("python-pytest" ,python-pytest)
       ("python-responses" ,python-responses)
       ("python-pyyaml" ,python-pyyaml)
       ("python-anaconda-client" ,python-anaconda-client)))
    (home-page "https://github.com/conda/conda")
    (synopsis "Cross-platform, OS-agnostic, system-level binary package manager")
    (description
     "Conda is a cross-platform, Python-agnostic binary package manager.  It
is the package manager used by Anaconda installations, but it may be used for
other systems as well.  Conda makes environments first-class citizens, making
it easy to create independent environments even for C libraries.  Conda is
written entirely in Python.

This package provides Conda as a library.")
    (license license:bsd-3)))

(define-public python2-conda
  (let ((base (package-with-python2
               (strip-python2-variant python-conda))))
    (package (inherit base)
             (native-inputs
              `(("python2-enum34" ,python2-enum34)
                ,@(package-native-inputs base))))))

(define-public conda
  (package (inherit python-conda)
    (name "conda")
    (arguments
     (substitute-keyword-arguments (package-arguments python-conda)
       ((#:phases phases)
        `(modify-phases ,phases
           (replace 'build
             (lambda* (#:key outputs #:allow-other-keys)
               ;; This test fails when run before installation.
               (delete-file "tests/test_activate.py")

               ;; Fix broken defaults
               (substitute* "conda/base/context.py"
                 (("return sys.prefix")
                  (string-append "return \"" (assoc-ref outputs "out") "\""))
                 (("return (prefix_is_writable\\(self.root_prefix\\))" _ match)
                  (string-append "return False if self.root_prefix == self.conda_prefix else "
                                 match)))

               ;; The util/setup-testing.py is used to build conda in
               ;; application form, rather than the default, library form.
               ;; With this, we are able to run commands like `conda --help`
               ;; directly on the command line
               (zero? (system* "python" "utils/setup-testing.py" "build_py"))))
           (replace 'install
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (target (string-append out "/lib/python"
                                             ((@@ (guix build python-build-system)
                                                  get-python-version)
                                              (assoc-ref inputs "python"))
                                             "/site-packages/")))
                 ;; The installer aborts if the target directory is not on
                 ;; PYTHONPATH.
                 (setenv "PYTHONPATH"
                         (string-append target ":" (getenv "PYTHONPATH")))

                 ;; And it aborts if the directory doesn't exist.
                 (mkdir-p target)
                 (zero? (system* "python" "utils/setup-testing.py" "install"
                                 (string-append "--prefix=" out))))))
           ;; The "activate" and "deactivate" scripts don't need wrapping.
           ;; They also break when they are renamed.
           (add-after 'wrap 'undo-wrap
             (lambda* (#:key outputs #:allow-other-keys)
               (with-directory-excursion (string-append (assoc-ref outputs "out") "/bin/")
                 (delete-file "deactivate")
                 (rename-file ".deactivate-real" "deactivate")
                 (delete-file "activate")
                 (rename-file ".activate-real" "activate")
                 #t)))))))
    (description
     "Conda is a cross-platform, Python-agnostic binary package manager.  It
is the package manager used by Anaconda installations, but it may be used for
other systems as well.  Conda makes environments first-class citizens, making
it easy to create independent environments even for C libraries.  Conda is
written entirely in Python.")))

(define-public gwl
  (package
    (name "gwl")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.guixwl.org/releases/gwl-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "06pm967mq1wyggx7l0nfapw5s0k5qc5r9lawk2v3db868br779a7"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("guile" ,guile-2.2)))
    (propagated-inputs
     `(("guix" ,guix)
       ("guile-commonmark" ,guile-commonmark)))
    (home-page "https://www.guixwl.org")
    (synopsis "Workflow management extension for GNU Guix")
    (description "This project provides two subcommands to GNU Guix and
introduces two record types that provide a workflow management extension built
on top of GNU Guix.")
    ;; The Scheme modules in guix/ and gnu/ are licensed GPL3+,
    ;; the web interface modules in gwl/ are licensed AGPL3+,
    ;; and the fonts included in this package are licensed OFL1.1.
    (license (list license:gpl3+ license:agpl3+ license:silofl1.1))))

(define-public gcab
  (package
    (name "gcab")
    (version "1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnome/sources/" name "/"
                                  version "/" name "-" version ".tar.xz"))
              (sha256
               (base32
                "0l19sr6pg0cfcddmi5n79d08mjjbhn427ip5jlsy9zddq9r24aqr"))
              ;; gcab 1.1 has a hard dependency on git — even when building
              ;; from a tarball.  Remove it early so ‘guix environment gcab’
              ;; can actually build what ‘guix build --source gcab’ returns.
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (substitute* "meson.build"
                    (("git_version = .*$") "git_version = []\n"))
                  #t))))
    (build-system meson-build-system)
    (native-inputs
     `(("glib:bin" ,glib "bin")         ; for glib-mkenums
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("vala" ,vala)))
    (inputs
     `(("glib" ,glib)
       ("zlib" ,zlib)))
    (arguments
     `(#:configure-flags
       ;; XXX This ‘documentation’ is for developers, and fails informatively:
       ;; Error in gtkdoc helper script: 'gtkdoc-mkhtml' failed with status 5
       (list "-Ddocs=false"
             "-Dintrospection=false")))
    (home-page "https://wiki.gnome.org/msitools") ; no dedicated home page
    (synopsis "Microsoft Cabinet file manipulation library")
    (description
     "The libgcab library provides GObject functions to read, write, and modify
Microsoft cabinet (.@dfn{CAB}) files.")
    (license (list license:gpl2+        ; tests/testsuite.at
                   license:lgpl2.1+)))) ; the rest

(define-public msitools
  (package
    (name "msitools")
    (version "0.97")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnome/sources/" name "/"
                                  version "/" name "-" version ".tar.xz"))
              (sha256
               (base32
                "0pn6izlgwi4ngpk9jk2n38gcjjpk29nm15aad89bg9z3k9n2hnrs"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("gcab" ,gcab)
       ("glib" ,glib)
       ("libgsf" ,libgsf)
       ("libxml2" ,libxml2)
       ("uuid" ,util-linux)))
    (home-page "https://wiki.gnome.org/msitools")
    (synopsis "Windows Installer file manipulation tool")
    (description
     "msitools is a collection of command-line tools to inspect, extract, build,
and sign Windows@tie{}Installer (.@dfn{MSI}) files.  It aims to be a solution
for packaging and deployment of cross-compiled Windows applications.")
    (license license:lgpl2.1+)))
