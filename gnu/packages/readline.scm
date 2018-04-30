;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Jan Nieuwenhuizen <janneke@gnu.org>
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

(define-module (gnu packages readline)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages perl)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (ice-9 format))

(define (patch-url seqno)
  (format #f "mirror://gnu/readline/readline-7.0-patches/readline70-~3,'0d" seqno))

(define (readline-patch seqno sha256)
  "Return the origin of Readline patch SEQNO, with expected hash SHA256"
  (origin
    (method url-fetch)
    (uri (patch-url seqno))
    (sha256 sha256)))

(define-syntax-rule (patch-series (seqno hash) ...)
  (list (readline-patch seqno (base32 hash))
        ...))

(define %patch-series-7.0
  (patch-series
   (1 "0xm3sxvwmss7ddyfb11n6pgcqd1aglnpy15g143vzcf75snb7hcs")
   (2 "0n1dxmqsbjgrfxb1hgk5c6lsraw4ncbnzxlsx7m35nym6lncjiw7")
   (3 "1027kmymniizcy0zbdlrczxfx3clxcdln5yq05q9yzlc6y9slhwy")))

(define-public readline
  (package
    (name "readline")
    (version (string-append "7.0."
                            (number->string (length %patch-series-7.0))))
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/readline/readline-"
                                  (version-major+minor version) ".tar.gz"))
              (sha256
               (base32
                "0d13sg9ksf982rrrmv5mb6a2p4ys9rvg9r71d6il0vr8hmql63bm"))
              (patches (append
                        %patch-series-7.0
                        (search-patches "readline-link-ncurses.patch")))
              (patch-flags '("-p0"))))
    (build-system gnu-build-system)
    (propagated-inputs `(("ncurses" ,ncurses)))
    (arguments `(#:configure-flags
                 (list (string-append "LDFLAGS=-Wl,-rpath -Wl,"
                                      (assoc-ref %build-inputs "ncurses")
                                      "/lib")

                       ;; This test does an 'AC_TRY_RUN', which aborts when
                       ;; cross-compiling, so provide the correct answer.
                       ,@(if (%current-target-system)
                             '("bash_cv_wcwidth_broken=no")
                             '())
                       ;; MinGW: ncurses provides the termcap api.
                       ,@(if (target-mingw?)
                             '("bash_cv_termcap_lib=ncurses")
                             '()))

                 ,@(if (target-mingw?)
                       ;; MinGW: termcap in ncurses
                       ;; some SIG_* #defined in _POSIX
                       '(#:make-flags '("TERMCAP_LIB=-lncurses"
                                        "CPPFLAGS=-D_POSIX -D'chown(f,o,g)=0'"))
                       '())))
    (synopsis "Edit command lines while typing, with history support")
    (description
     "The GNU readline library allows users to edit command lines as they
are typed in.  It can maintain a searchable history of previously entered
commands, letting you easily recall, edit and re-enter past commands.  It
features both Emacs-like and vi-like keybindings, making its usage
comfortable for anyone.")
    (license gpl3+)
    (home-page "https://savannah.gnu.org/projects/readline/")))

(define-public readline-6.2
  (package (inherit readline)
    (version "6.2")
    (source (origin (inherit (package-source readline))
              (method url-fetch)
              (uri (string-append "mirror://gnu/readline/readline-"
                                  version ".tar.gz"))
              (patches (search-patches "readline-6.2-CVE-2014-2524.patch"))
              (patch-flags '("-p0"))
              (sha256
               (base32
                "10ckm2bd2rkxhvdmj7nmbsylmihw0abwcsnxf8y27305183rd9kr"))))))

(define-public rlwrap
  (package
    (name "rlwrap")
    (version "0.43")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/hanslub42/rlwrap/releases/"
                            "download/v" version "/"
                            name "-" version ".tar.gz"))
        (sha256
         (base32
          "0bzb7ylk2770iv59v2d0gypb21y2xn87m299s9rqm6rdi2vx11lf"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("perl" ,perl)))
    (inputs
     `(("readline" ,readline)))
    (synopsis "Wrapper to allow the editing of keyboard commands")
    (description
     "Rlwrap is a 'readline wrapper', a small utility that uses the GNU
readline library to allow the editing of keyboard input for any command.  You
should consider rlwrap especially when you need user-defined completion (by way
of completion word lists) and persistent history, or if you want to program
'special effects' using the filter mechanism.")
    (home-page "https://github.com/hanslub42/rlwrap")
    (license gpl2+)))
