;;; Copyright © 2016, 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
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

(define-module (gnu packages syndication)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml))

(define-public newsboat
  (package
    (name "newsboat")
    (version "2.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://newsboat.org/releases/" version
                           "/newsboat-" version ".tar.xz"))
       (sha256
        (base32
         "1krpxl854h5dwmpr81m1s84cwk8zivdzvw0s5s0i4dba736pvdma"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("pkg-config" ,pkg-config)
       ;; For building documentation.
       ("asciidoc" ,asciidoc)))
    (inputs
     `(("curl" ,curl)
       ("json-c" ,json-c)
       ("libxml2" ,libxml2)
       ("ncurses" ,ncurses)
       ("stfl" ,stfl)
       ("sqlite" ,sqlite)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; no configure script
         (add-after 'build 'build-documentation
           (lambda _
             (zero? (system* "make" "doc")))))
       #:make-flags
       (list (string-append "prefix=" (assoc-ref %outputs "out")))
       #:test-target "test"))
    (native-search-paths
     ;; Newsboat respects CURL_CA_BUNDLE.
     (package-native-search-paths curl))
    (home-page "https://newsboat.org/")
    (synopsis "Text-mode RSS and Atom feed reader with podcast support")
    (description "Newsboat is a feed reader for @dfn{RSS} and @dfn{Atom}, XML
formats widely used to transmit, publish, and syndicate news or blog articles.
It's designed for use on text terminals, and to have a coherent and easy-to-use
interface that might look familiar to @command{mutt} or @command{slrn} users.

Newsboat supports OPML import/exports, HTML rendering, podcasts (with
@command{podboat}), off-line reading, searching and storing articles to your
file system, and many more features.

It started life as a fork of the currently unmaintained Newsbeuter.")
    (license (list license:gpl2+        ; filter/*
                   license:expat))))    ; everything else

(define-public newsbeuter
  ;; Newsbeuter is unmaintained with multiple CVEs, and was forked as Newsboat.
  (deprecated-package "newsbeuter" newsboat))
