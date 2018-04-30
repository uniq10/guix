;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014, 2016, 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2016 Leo Famulari <leo@famulari.name>
;;; Copyright © 2017 Rene Saavedra <rennes@openmailbox.org>
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

(define-module (gnu packages bdw-gc)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages hurd))

(define-public libgc
  (package
   (name "libgc")
   (version "7.6.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "http://www.hboehm.info/gc/gc_source/gc-"
                                version ".tar.gz"))
            (sha256
             (base32
              "143x7g0d0k6250ai6m2x3l4y352mzizi4wbgrmahxscv2aqjhjm1"))))
   (build-system gnu-build-system)
   (arguments
    `(#:configure-flags
      (list
       ;; Install gc_cpp.h et al.
       "--enable-cplusplus"
       ;; In GNU/Hurd systems during the 'Check' phase,
       ;; there is a deadlock caused by the 'gctest' test.
       ;; To disable the error set "--disable-gcj-support"
       ;; to configure script. See bug report and discussion:
       ;; <https://lists.opendylan.org/pipermail/bdwgc/2017-April/006275.html>
       ;; <https://lists.gnu.org/archive/html/bug-hurd/2017-01/msg00008.html>
       ,@(if (hurd-triplet? (or (%current-system)
                                (%current-target-system)))
             '("--disable-gcj-support")
             '()))))
   (native-inputs `(("pkg-config" ,pkg-config)))
   (inputs `(("libatomic-ops" ,libatomic-ops)))
   (outputs '("out" "debug"))
   (synopsis "The Boehm-Demers-Weiser conservative garbage collector
for C and C++")
   (description
    "The Boehm-Demers-Weiser conservative garbage collector can be used
as a garbage collecting replacement for C malloc or C++ new.  It allows
you to allocate memory basically as you normally would, without
explicitly deallocating memory that is no longer useful.  The collector
automatically recycles memory when it determines that it can no longer
be otherwise accessed.

The collector is also used by a number of programming language
implementations that either use C as intermediate code, want to
facilitate easier interoperation with C libraries, or just prefer the
simple collector interface.

Alternatively, the garbage collector may be used as a leak detector for
C or C++ programs, though that is not its primary goal.")
   (home-page "http://www.hboehm.info/gc/")

   (license (x11-style (string-append home-page "license.txt")))))

(define-public libgc/back-pointers
  (package
    (inherit libgc)
    (name "libgc-back-pointers")
    (arguments
     `(#:make-flags
       (list "CPPFLAGS=-DKEEP_BACK_PTRS=1")
       ,@(package-arguments libgc)))
    (synopsis "The BDW garbage collector, with back-pointer tracking")))

(define-public libatomic-ops
  (package
    (name "libatomic-ops")
    (version "7.4.8")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/ivmai/libatomic_ops/releases/download/v"
                    version "/libatomic_ops-" version ".tar.gz"))
              (sha256
               (base32
                "0sj3plzpbqgxrqpjq3w2zi3zxxqqps71ncdwk5s1k30i9d9da1f4"))))
    (build-system gnu-build-system)
    (outputs '("out" "debug"))
    (synopsis "Accessing hardware atomic memory update operations")
    (description
     "This C library provides semi-portable access to hardware-provided atomic
memory update operations on a number architectures.  These might allow you to
write code that does more interesting things in signal handlers, write
lock-free code, experiment with thread programming paradigms, etc.")
    (home-page "https://github.com/ivmai/libatomic_ops/")

    ;; Some source files are X11-style, others are GPLv2+.
    (license gpl2+)))
