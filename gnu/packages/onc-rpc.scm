;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014, 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016 John Darrington <jmd@gnu.org>
;;; Copyright © 2017, 2018 Leo Famulari <leo@famulari.name>
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

(define-module (gnu packages onc-rpc)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system gnu))

(define-public libtirpc
  (package
    (name "libtirpc")
    (version "1.0.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/libtirpc/libtirpc/"
                                  version "/libtirpc-"
                                  version ".tar.bz2"))
              (sha256
               (base32
                "0ppxl3k3nsz0qdakq844i2kj4fvh9h937lhx26bgmpmxq67sghw6"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'remote-dangling-symlink
           (lambda _
             (substitute* '("man/netconfig.5"
                            "man/getnetconfig.3t"
                            "man/getnetpath.3t"
                            "man/rpc.3t"
                            "src/getnetconfig.c"
                            "tirpc/netconfig.h")
               (("/etc/netconfig") (string-append %output "/etc/netconfig")))

             ;; Remove the dangling symlinks since it breaks the
             ;; 'patch-source-shebangs' file tree traversal.
             (delete-file "INSTALL")
             #t)))))
    (inputs `(("mit-krb5" ,mit-krb5)))
    (home-page "https://sourceforge.net/projects/libtirpc/")
    (synopsis "Transport-independent Sun/ONC RPC implementation")
    (description
     "This package provides a library that implements the Sun/ONC RPC (remote
procedure calls) protocol in a transport-independent manner.  It supports both
IPv4 and IPv6.  ONC RPC is notably used by the network file system (NFS).")
    (license bsd-3)))

(define-public rpcbind
  (package
    (name "rpcbind")
    (version "0.2.4")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://sourceforge/" name "/" name "/"
                          version "/"
                          name "-" version ".tar.bz2"))
      (patches (search-patches "rpcbind-CVE-2017-8779.patch"))
      (sha256
       (base32
        "0rjc867mdacag4yqvs827wqhkh27135rp9asj06ixhf71m9rljh7"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       `("--with-systemdsystemunitdir=no" "--enable-warmstarts")))
    (inputs
     `(("libnsl" ,libnsl)
       ("libtirpc" ,libtirpc)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "http://rpcbind.sourceforge.net/")
    (synopsis "Server to convert RPC program numbers into universal addresses")
    (description
     "@command{Rpcbind} is a server that converts RPC program numbers into
universal addresses.")
    (license bsd-3)))


(define-public libnsl
  (package
    (name "libnsl")
    (version "1.2.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/thkukuk/libnsl/archive/v"
                                  version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1y6kmxmv1difzvdhx7grqzw0j2v2b74mg4kjb803m8jcgkqqx8m5"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'bootstrap
           (lambda _
             (invoke "sh" "autogen.sh"))))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("gettext" ,gettext-minimal)
       ("libtool" ,libtool)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("libtirpc" ,libtirpc)))
    (synopsis "Public client interface for NIS(YP) and NIS+")
    (description "Libnsl is the public client interface for the Network
Information Service / Yellow Pages (NIS/YP) and NIS+.  It includes IPv6 support.
This library was part of glibc < 2.26, but is now distributed separately.")
    (home-page "https://github.com/thkukuk/libnsl")
    ;; The package is distributed under the LGPL 2.1. Some files in
    ;; 'src/nisplus/' are LGPL 2.1+, and some files in 'src/rpcsvc/' are BSD-3.
    (license lgpl2.1)))
