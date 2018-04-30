;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Siniša Biđin <sinisa@bidin.eu>
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

(define-module (gnu packages conky)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages image)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xorg))

(define-public conky
  (package
    (name "conky")
    (version "1.10.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/brndnmtthws/conky/archive/v"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mw8xbnxr0a7yq2smzi2nln2b5n0q571vdrq6mhvs5n84xd6bg9f"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f ; there are no tests
       #:configure-flags
       (list "-DRELEASE=true")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'add-freetype-to-search-path
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "cmake/ConkyPlatformChecks.cmake"
               (("set\\(INCLUDE_SEARCH_PATH")
                (string-append
                 "set(INCLUDE_SEARCH_PATH "
                 (assoc-ref inputs "freetype") "/include/freetype2 ")))
             #t))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin")))
               (install-file "src/conky" bin))
             #t)))))
    (inputs
     `(("freetype" ,freetype)
       ("imlib2" ,imlib2)
       ("libx11" ,libx11)
       ("libxdamage" ,libxdamage)
       ("libxext" ,libxext)
       ("libxft" ,libxft)
       ("libxinerama" ,libxinerama)
       ("lua" ,lua)
       ("ncurses" ,ncurses)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "https://github.com/brndnmtthws/conky")
    (synopsis "Lightweight system monitor for X")
    (description
     "Conky is a lightweight system monitor for X that displays operating
system statistics (CPU, disk, and memory usage, etc.) and more on the
desktop.")
    (license license:gpl3+)))
