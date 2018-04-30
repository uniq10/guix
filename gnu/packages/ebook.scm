;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017 Alex Griffin <a@ajgrf.com>
;;; Copyright © 2017 Brendan Tildesley <brendan.tildesley@openmailbox.org>
;;; Copyright © 2017 Roel Janssen <roel@gnu.org>
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

(define-module (gnu packages ebook)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg))

(define-public chmlib
  (package
    (name "chmlib")
    (version "0.40")
    (source (origin
             (method url-fetch)
             (uri (string-append "http://www.jedrea.com/chmlib/chmlib-"
                                 version ".tar.bz2"))
             (sha256
               (base32
                "18zzb4x3z0d7fjh1x5439bs62dmgsi4c1pg3qyr7h5gp1i5xcj9l"))
             (patches (search-patches "chmlib-inttypes.patch"))))
    (build-system gnu-build-system)
    (home-page "http://www.jedrea.com/chmlib/")
    (synopsis "Library for CHM files")
    (description "CHMLIB is a library for dealing with ITSS/CHM format files.")
    (license license:lgpl2.1+)))

(define-public calibre
  (package
    (name "calibre")
    (version "3.17.0")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "http://download.calibre-ebook.com/"
                            version "/calibre-"
                            version ".tar.xz"))
        (sha256
         (base32
          "1w6hw1s0d4daa4q2ykzhxdndiq61l8z7ls7rxh7k7p62ia0i5sxp"))
        ;; Remove non-free or doubtful code, see
        ;; https://lists.gnu.org/archive/html/guix-devel/2015-02/msg00478.html
        (modules '((guix build utils)))
        (snippet
          '(begin
            (delete-file-recursively "src/calibre/ebooks/markdown")
            (delete-file "src/odf/thumbnail.py")
            (delete-file-recursively "resources/fonts/liberation")
            (substitute* (find-files "." "\\.py")
              (("calibre\\.ebooks\\.markdown") "markdown"))
            #t))
        (patches (search-patches "calibre-use-packaged-feedparser.patch"
                                 "calibre-no-updates-dialog.patch"))))
    (build-system python-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("font-liberation" ,font-liberation)
       ("qtbase" ,qtbase) ; for qmake
       ;; xdg-utils is supposed to be used for desktop integration, but it
       ;; also creates lots of messages
       ;; mkdir: cannot create directory '/homeless-shelter': Permission denied
       ("python2-flake8" ,python2-flake8)
       ("xdg-utils" ,xdg-utils)))
    ;; Beautifulsoup3 is bundled but obsolete and not packaged, so just leave it bundled.
    (inputs
     `(("chmlib" ,chmlib)
       ("fontconfig" ,fontconfig)
       ("glib" ,glib)
       ("icu4c" ,icu4c)
       ("libmtp" ,libmtp)
       ("libpng" ,libpng)
       ("libusb" ,libusb)
       ("libxrender" ,libxrender)
       ("openssl" ,openssl)
       ("optipng" ,optipng)
       ("podofo" ,podofo)
       ("poppler" ,poppler)
       ("python" ,python-2)
       ("python2-apsw" ,python2-apsw)
       ("python2-chardet" ,python2-chardet)
       ("python2-cssselect" ,python2-cssselect)
       ("python2-cssutils" ,python2-cssutils)
       ("python2-dateutil" ,python2-dateutil)
       ("python2-dbus" ,python2-dbus)
       ("python2-dnspython" ,python2-dnspython)
       ("python2-dukpy" ,python2-dukpy)
       ("python2-feedparser" ,python2-feedparser)
       ("python2-html5-parser" ,python2-html5-parser)
       ("python2-lxml" ,python2-lxml)
       ("python2-markdown" ,python2-markdown)
       ("python2-mechanize" ,python2-mechanize)
       ;; python2-msgpack is needed for the network content server to work.
       ("python2-msgpack" ,python2-msgpack)
       ("python2-netifaces" ,python2-netifaces)
       ("python2-pillow" ,python2-pillow)
       ("python2-pygments" ,python2-pygments)
       ("python2-pyqt" ,python2-pyqt)
       ("python2-sip" ,python2-sip)
       ("python2-regex" ,python2-regex)
       ;; python2-unrardll is needed for decompressing RAR files.
       ;; A program called 'pdf2html' is needed for reading PDF books
       ;; in the web interface.
       ("sqlite" ,sqlite)))
    (arguments
     `(#:python ,python-2
       #:test-target "check"
       #:tests? #f ; FIXME: enable once flake8 is packaged
       ;; Calibre is using setuptools by itself, but the setup.py is not
       ;; compatible with the shim wrapper (taken from pip) we are using.
       #:use-setuptools? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-source
           (lambda _
             (substitute* "src/calibre/linux.py"
               ;; We can't use the uninstaller in Guix. Don't build it.
               (("self\\.create_uninstaller()") ""))
             #t))
         (add-after 'unpack 'dont-load-remote-icons
           (lambda _
             (substitute* "setup/plugins_mirror.py"
               (("href=\"//calibre-ebook.com/favicon.ico\"")
                "href=\"favicon.ico\""))
             #t))
         (add-before 'build 'configure
          (lambda* (#:key inputs #:allow-other-keys)
            (let ((podofo (assoc-ref inputs "podofo"))
                  (pyqt (assoc-ref inputs "python2-pyqt")))
              (substitute* "setup/build_environment.py"
                (("sys.prefix") (string-append "'" pyqt "'")))
              (setenv "PODOFO_INC_DIR" (string-append podofo "/include/podofo"))
              (setenv "PODOFO_LIB_DIR" (string-append podofo "/lib"))
              #t)))
         (add-after 'install 'install-font-liberation
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (for-each (lambda (file)
                         (install-file file (string-append
                                             (assoc-ref outputs "out")
                                             "/share/calibre/fonts/liberation")))
                       (find-files (string-append
                                    (assoc-ref inputs "font-liberation")
                                    "/share/fonts/truetype")))
             #t))
         (add-after 'install-font-liberation 'install-mimetypes
           (lambda* (#:key outputs #:allow-other-keys)
             (install-file "resources/calibre-mimetypes.xml"
                           (string-append (assoc-ref outputs "out")
                                          "/share/mime/packages"))
             #t)))))
    (home-page "http://calibre-ebook.com/")
    (synopsis "E-book library management software")
    (description "Calibre is an e-book library manager.  It can view, convert
and catalog e-books in most of the major e-book formats.  It can also talk
to many e-book reader devices.  It can go out to the Internet and fetch
metadata for books.  It can download newspapers and convert them into
e-books for convenient reading.")
    ;; Calibre is largely GPL3+, but includes a number of components covered
    ;; by other licenses. See COPYRIGHT for more details.
    (license (list license:gpl3+
                   license:gpl2+
                   license:lgpl2.1+
                   license:lgpl2.1
                   license:bsd-3
                   license:expat
                   license:zpl2.1
                   license:asl2.0
                   license:public-domain
                   license:silofl1.1
                   license:cc-by-sa3.0))))

(define-public liblinebreak
  (package
    (name "liblinebreak")
    (version "2.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/vimgadgets"
                                  "/liblinebreak/" version
                                  "/liblinebreak-" version ".tar.gz"))
              (sha256
               (base32
                "1f36dbq7nc77lln1by2n1yl050g9dc63viawhs3gc3169mavm36x"))))
    (build-system gnu-build-system)
    (home-page "http://vimgadgets.sourceforge.net/liblinebreak/")
    (synopsis "Library for detecting where linebreaks are allowed in text")
    (description "@code{liblinebreak} is an implementation of the line
breaking algorithm as described in Unicode 6.0.0 Standard Annex 14,
Revision 26.  It breaks lines that contain Unicode characters.  It is
designed to be used in a generic text renderer.")
    (license license:zlib)))

(define-public fbreader
  (package
    (name "fbreader")
    (version "0.99.6")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/geometer/FBReader/"
                                  "archive/" version "-freebsdport.tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0gf1nl562fqkwlzcn6rgkp1j8jcixzmfsnwxbc0sm49zh8n3zqib"))))
    (build-system gnu-build-system)
    (inputs
     `(("curl" ,curl)
       ("expat" ,expat)
       ("fribidi" ,fribidi)
       ("glib" ,glib)
       ("gtk+-2" ,gtk+-2)
       ("libjpeg" ,libjpeg)
       ("liblinebreak" ,liblinebreak)
       ("libxft" ,libxft)
       ("sqlite" ,sqlite)
       ("zlib" ,zlib)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (arguments
     `(#:tests? #f ; No tests exist.
       #:make-flags `("CC=gcc" "TARGET_ARCH=desktop" "UI_TYPE=gtk"
                      "TARGET_STATUS=release"
                      ,(string-append "INSTALLDIR="
                                      (assoc-ref %outputs "out"))
                      ,(string-append "LDFLAGS=-Wl,-rpath="
                                      (assoc-ref %outputs "out") "/lib"))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://fbreader.org/")
    (synopsis "E-Book reader")
    (description "@code{fbreader} is an E-Book reader.  It supports the
following formats:

@enumerate
@item CHM
@item Docbook
@item FB2
@item HTML
@item OEB
@item PDB
@item RTF
@item TCR
@item TXT
@item XHTML
@end enumerate")
    (license license:gpl2+)))
