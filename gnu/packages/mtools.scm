;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 John Darrington <jmd@gnu.org>
;;; Copyright © 2015 Ludovic Courtès <ludo@gnu.org>
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

(define-module (gnu packages mtools)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public mtools
  (package
    (name "mtools")
    (version "4.0.18")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/mtools/mtools-"
                          version ".tar.gz"))
      (sha256
       (base32
        "1hxciksv7av5ilnkvwbidyxxr1gzn24lr0mz9z8drkml7780im1h"))))
    (build-system gnu-build-system)
    (home-page "https://www.gnu.org/software/mtools/")
    (synopsis "Access MS-DOS disks without mounting")
    (description
     "GNU Mtools is a set of utilities for accessing MS-DOS disks from a GNU
or Unix system.  It supports long file names and multiple disk formats.  It
also supports some FAT-specific features such as volume labels and
FAT-specific file attributes.")
    (license gpl3+)))

(define-public exfat-utils
  (package
    (name "exfat-utils")
    (version "1.2.8")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/relan/exfat/releases/download/v"
                    version "/" name "-" version ".tar.gz"))
              (sha256
               (base32
                "09yf41mgwp8wg0psq347d5razllilx1sd4ij9173nri47p9465jw"))))
    (build-system gnu-build-system)
    (home-page "https://github.com/relan/exfat")
    (synopsis "Utilities to manipulate exFAT file systems")
    (description
     "This package provides an implementation of the exFAT file system,
including command-line tools to validate exFAT file systems and to create new
ones.")
    (license gpl2+)))
