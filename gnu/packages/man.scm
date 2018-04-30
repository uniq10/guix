;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2014, 2015, 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014 David Thompson <dthompson2@worcester.edu>
;;; Copyright © 2015, 2016 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2015 Alex Kost <alezost@gmail.com>
;;; Copyright © 2015, 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
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

(define-module (gnu packages man)
  #:use-module (guix licenses)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages less)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages linux))

(define-public libpipeline
  (package
    (name "libpipeline")
    (version "1.5.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://savannah/libpipeline/libpipeline-"
                    version ".tar.gz"))
              (sha256
               (base32
                "0avg525wvifcvjrwa6i1r6kvahmsswj0mpxrsxzzdzra9wpf2whd"))))
    (build-system gnu-build-system)
    (home-page "http://libpipeline.nongnu.org/")
    (synopsis "C library for manipulating pipelines of subprocesses")
    (description
     "libpipeline is a C library for manipulating pipelines of subprocesses in
a flexible and convenient way.")
    (license gpl3+)))

(define-public man-db
  (package
    (name "man-db")
    (version "2.8.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://savannah/man-db/man-db-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1b641kcgjvyc41pj67dn4p0zvwlj1vx3l6nf7qdcc7kf6v5a2cjr"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'patch-source-shebangs 'patch-test-shebangs
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Patch shebangs in test scripts.
             (let ((out (assoc-ref outputs "out")))
               (for-each (lambda (file)
                           (substitute* file
                             (("#! /bin/sh")
                              (string-append "#!" (which "sh")))))
                         (remove file-is-directory?
                                 (find-files "src/tests" ".*"))))))
         (add-after 'unpack 'patch-iconv-path
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "src/man.c"
               (("\"iconv\"")
                (string-append "\"" (which "iconv") "\"")))
             #t)))
       #:configure-flags
       (let ((groff (assoc-ref %build-inputs "groff"))
             (groff-minimal (assoc-ref %build-inputs "groff-minimal"))
             (less  (assoc-ref %build-inputs "less"))
             (gzip  (assoc-ref %build-inputs "gzip"))
             (bzip2 (assoc-ref %build-inputs "bzip2"))
             (xz    (assoc-ref %build-inputs "xz"))
             (util  (assoc-ref %build-inputs "util-linux")))
         ;; Invoke groff, less, gzip, bzip2, and xz directly from the store.
         (append (list ;; Disable setuid man user.
                       "--disable-setuid"
                       ;; Don't constrain ownership of system-wide cache files.
                       ;; Otherwise creating the manpage database fails with
                       ;; man-db > 2.7.5.
                       "--disable-cache-owner"
                       (string-append "--with-pager=" less "/bin/less")
                       (string-append "--with-gzip=" gzip "/bin/gzip")
                       (string-append "--with-bzip2=" bzip2 "/bin/gzip")
                       (string-append "--with-xz=" xz "/bin/xz")
                       (string-append "--with-col=" util "/bin/col")
                       ;; Default value is "/usr/lib/tmpfiles.d" (not
                       ;; prefix-sensitive).
                       (string-append "--with-systemdtmpfilesdir="
                                      %output "/lib/tmpfiles.d"))
                 (map (lambda (prog)
                        (string-append "--with-" prog "=" groff-minimal
                                       "/bin/" prog))
                      '("nroff" "eqn" "neqn" "tbl" "refer" "pic"))))

       ;; At run time we should refer to GROFF-MINIMAL, not GROFF (the latter
       ;; pulls in Perl.)
       #:disallowed-references (,groff)

       #:modules ((guix build gnu-build-system)
                  (guix build utils)
                  (srfi srfi-1))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("groff" ,groff)))   ;needed at build time (troff, grops, soelim, etc.)
    (inputs
     `(("flex" ,flex)
       ("gdbm" ,gdbm)
       ("groff-minimal" ,groff-minimal)
       ("less" ,less)
       ("libpipeline" ,libpipeline)
       ;; FIXME: 4.8 and later can use libseccomp, but it causes test
       ;; failures in the build chroot.
       ;;("libseccomp" ,libseccomp)
       ("util-linux" ,util-linux)))
    (native-search-paths
     (list (search-path-specification
            (variable "MANPATH")
            (files '("share/man")))))
    (home-page "http://man-db.nongnu.org/")
    (synopsis "Standard Unix documentation system")
    (description
     "Man-db is an implementation of the standard Unix documentation system
accessed using the man command.  It uses a Berkeley DB database in place of
the traditional flat-text whatis databases.")
    (license gpl2+)))

(define-public man-pages
  (package
    (name "man-pages")
    (version "4.15")
    (source (origin
              (method url-fetch)
              (uri
                (list
                  (string-append
                    "mirror://kernel.org/linux/docs/man-pages/man-pages-"
                    version ".tar.xz")
                  (string-append
                    "mirror://kernel.org/linux/docs/man-pages/Archive/"
                    "man-pages-" version ".tar.xz")))
              (sha256
               (base32
                "01n1rq1kvambax85xamriawbga94mh63s5mgjmjljjgf50m7yw6f"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases (modify-phases %standard-phases (delete 'configure))

       ;; The 'all' target depends on three targets that directly populate
       ;; $(MANDIR) based on its current contents.  Doing that in parallel
       ;; leads to undefined behavior (see <http://bugs.gnu.org/18701>.)
       #:parallel-build? #f

       #:tests? #f
       #:make-flags (list (string-append "MANDIR="
                                         (assoc-ref %outputs "out")
                                         "/share/man"))))
    (home-page "https://www.kernel.org/doc/man-pages/")
    (synopsis "Development manual pages from the Linux project")
    (description
     "This package provides traditional Unix \"man pages\" documenting the
Linux kernel and C library interfaces employed by user-space programs.")

    ;; Each man page has its own license; some are GPLv2+, some are MIT/X11.
    (license gpl2+)))

(define-public help2man
  (package
    (name "help2man")
    (version "1.47.5")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/help2man/help2man-"
                          version ".tar.xz"))
      (sha256
       (base32
        "1cb14kp380jzk1yi4i7x9d8qplc8c5mgcbgycgs9ggpx34jhp9kw"))))
    (build-system gnu-build-system)
    (arguments `(;; There's no `check' target.
                 #:tests? #f))
    (inputs
     `(("perl" ,perl)
       ;; TODO: Add these optional dependencies.
       ;; ("perl-LocaleGettext" ,perl-LocaleGettext)
       ;; ("gettext" ,gettext-minimal)
       ))
    (home-page "https://www.gnu.org/software/help2man/")
    (synopsis "Automatically generate man pages from program --help")
    (description
     "GNU help2man is a program that converts the output of standard
\"--help\" and \"--version\" command-line arguments into a manual page
automatically.")
    (license gpl3+)))

(define-public txt2man
  (package
    (name "txt2man")
    (version "1.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/mvertes/txt2man/archive/txt2man-"
             version ".tar.gz"))
       (sha256
        (base32
         "168cj96974n2z0igin6j1ic1m45zyic7nm5ark7frq8j78rrx4zn"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no "check" target
       #:make-flags (list (string-append "prefix=" (assoc-ref %outputs "out")))
       #:phases (modify-phases %standard-phases (delete 'configure))))
    (inputs
     `(("gawk" ,gawk)))
    (home-page "https://github.com/mvertes/txt2man")
    (synopsis "Convert text to man page")
    (description "Txt2man converts flat ASCII text to man page format.")
    (license gpl2+)))
