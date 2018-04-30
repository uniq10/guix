;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 John Darrington <jmd@gnu.org>
;;; Copyright © 2013 Nikita Karetnikov <nikita@karetnikov.org>
;;; Copyright © 2014, 2016 David Thompson <dthompson2@worcester.edu>
;;; Copyright © 2014, 2015, 2016, 2017 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2014 Cyrill Schenkel <cyrill.schenkel@gmail.com>
;;; Copyright © 2014 Sylvain Beucler <beuc@beuc.net>
;;; Copyright © 2014, 2015 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014, 2015, 2016 Sou Bunnbu <iyzsong@gmail.com>
;;; Copyright © 2014, 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015, 2016 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2015 David Hashe <david.hashe@dhashe.com>
;;; Copyright © 2015, 2017 Christopher Allan Webber <cwebber@dustycloud.org>
;;; Copyright © 2015, 2016, 2017, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2015, 2016, 2017 Alex Kost <alezost@gmail.com>
;;; Copyright © 2015 Paul van der Walt <paul@denknerd.org>
;;; Copyright © 2016, 2017 Rodger Fox <thylakoid@openmailbox.org>
;;; Copyright © 2016, 2017, 2018 Nils Gillmann <ng0@n0.is>
;;; Copyright © 2016 Albin Söderqvist <albin@fripost.org>
;;; Copyright © 2016, 2017, 2018 Kei Kebreau <kkebreau@posteo.net>
;;; Copyright © 2016 Alex Griffin <a@ajgrf.com>
;;; Copyright © 2016, 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Jan Nieuwenhuizen <janneke@gnu.org>
;;; Copyright © 2016 Steve Webber <webber.sl@gmail.com>
;;; Copyright © 2017 Adonay "adfeno" Felipe Nogueira <https://libreplanet.org/wiki/User:Adfeno> <adfeno@hyperbola.info>
;;; Copyright © 2017, 2018 Arun Isaac <arunisaac@systemreboot.net>
;;; Copyright © 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2017 nee <nee-git@hidamari.blue>
;;; Copyright © 2017 Clément Lassieur <clement@lassieur.org>
;;; Copyright © 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2017, 2018 Rutger Helling <rhelling@mykolab.com>
;;; Copyright © 2017 Roel Janssen <roel@gnu.org>
;;; Copyright © 2017, 2018 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2018 okapi <okapi@firemail.cc>
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

(define-module (gnu packages games)
  #:use-module (ice-9 match)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix svn-download)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages base)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages avahi)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages fltk)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages game-development)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gimp)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gperf)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages libedit)
  #:use-module (gnu packages libunwind)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages music)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages netpbm)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages python)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages check)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages video)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages cyrus-sasl)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages upnp)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages web)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system haskell)
  #:use-module (guix build-system python)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system trivial))

(define-public armagetronad
  (package
    (name "armagetronad")
    (version "0.2.8.3.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/" name "/stable/"
                                  version "/" name "-" version ".src.tar.gz"))
              (sha256
               (base32
                "1pgy0r80z702qdv94aw3ywdn4ynnr4cdi86ml558pljfc5ygasj4"))))
    (build-system gnu-build-system)
    (inputs
     `(("libxml2" ,libxml2)
       ("sdl" ,sdl)
       ("sdl-image" ,sdl-image)
       ("freeglut" ,freeglut)
       ("libpng" ,libpng)
       ("libjpeg-turbo" ,libjpeg-turbo)))
    (home-page "http://www.armagetronad.org")
    (synopsis "Tron clone in 3D")
    (description "Armagetron is a multiplayer game in 3d that attempts to
emulate and expand on the lightcycle sequence from the movie Tron.  It's
an old school arcade game slung into the 21st century.  Highlights include
a customizable playing arena, HUD, unique graphics, and AI bots.  For the
more advanced player there are new game modes and a wide variety of physics
settings to tweak as well.")
    (license license:gpl2+)))

(define-public cataclysm-dda
  (package
    (name "cataclysm-dda")
    (version "0.C")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/CleverRaven/Cataclysm-DDA/"
                                  "archive/" version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xlajmgl9cviqyjpp5g5q4rbljy9gqc49v54bi8gpzr68s14gsb9"))
              (modules '((guix build utils)))
              (snippet
               ;; Import cmath header for the std::pow function.
               '(for-each (lambda (file)
                            (substitute* file
                              (("#include <math.h>")
                               "#include <cmath>")))
                          (find-files "src")))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out"))
                          "USE_HOME_DIR=1" "DYNAMIC_LINKING=1" "RELEASE=1")
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda _
             (substitute* "Makefile"
               (("ncursesw5-config") "ncursesw6-config")
               (("RELEASE_FLAGS = -Werror") "RELEASE_FLAGS ="))
             #t))
         (add-after 'build 'build-tiles
           (lambda* (#:key make-flags outputs #:allow-other-keys)
             ;; Change prefix directory and enable tile graphics and sound.
             (zero?
              (apply system* "make" "TILES=1" "SOUND=1"
                     (string-append "PREFIX="
                                    (assoc-ref outputs "tiles"))
                     (cdr make-flags)))))
         (add-after 'install 'install-tiles
           (lambda* (#:key make-flags outputs #:allow-other-keys)
             (zero?
              (apply system* "make" "install" "TILES=1" "SOUND=1"
                     (string-append "PREFIX="
                                    (assoc-ref outputs "tiles"))
                     (cdr make-flags))))))
       ;; TODO: Add libtap++ from https://github.com/cbab/libtappp as a native
       ;;       input in order to support tests.
       #:tests? #f))
    (outputs '("out"
               "tiles")) ; For tile graphics and sound support.
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("freetype" ,freetype)
       ("libogg" ,libogg)
       ("libvorbis" ,libvorbis)
       ("ncurses" ,ncurses)
       ("sdl2" ,sdl2)
       ("sdl2-image" ,sdl2-image)
       ("sdl2-ttf" ,sdl2-ttf)
       ("sdl2-mixer" ,sdl2-mixer)))
    (home-page "http://en.cataclysmdda.com/")
    (synopsis "Survival horror roguelike video game")
    (description
     "Cataclysm: Dark Days Ahead is a roguelike set in a post-apocalyptic world.
Struggle to survive in a harsh, persistent, procedurally generated world.
Scavenge the remnants of a dead civilization for food, equipment, or, if you are
lucky, a vehicle with a full tank of gas to get you out of Dodge.  Fight to
defeat or escape from a wide variety of powerful monstrosities, from zombies to
giant insects to killer robots and things far stranger and deadlier, and against
the others like yourself, that want what you have.")
    (license license:cc-by-sa3.0)))

(define-public cowsay
  (package
    (name "cowsay")
    (version "3.04")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/tnalpgge/"
                                  "rank-amateur-cowsay/archive/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "12w7apbf6a9qffk92r32b16w22na2fjcqbl32rn0n7zw5hrp3f6q"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; no configure script
         (delete 'build)                ; nothing to be built
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (zero? (system* "sh" "install.sh"
                             (assoc-ref outputs "out")))))
         (delete 'check)
         (add-after 'install 'check
           (lambda* (#:key outputs #:allow-other-keys)
             (zero? (system* (string-append (assoc-ref outputs "out")
                                            "/bin/cowsay")
                             "We're done!")))))))
    (inputs
     `(("perl" ,perl)))
    (home-page (string-append "https://web.archive.org/web/20071026043648/"
                              "http://www.nog.net:80/~tony/warez/cowsay.shtml"))
    (synopsis "Speaking cow text filter")
    (description "Cowsay is basically a text filter.  Send some text into it,
and you get a cow saying your text.  If you think a talking cow isn't enough,
cows can think too: all you have to do is run @command{cowthink}.  If you're
tired of cows, a variety of other ASCII-art messengers are available.")
    (license license:gpl3+)))

(define-public freedoom
  (package
   (name "freedoom")
   (version "0.11.3")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/" name "/" name
                                "/archive/v" version ".tar.gz"))
            (file-name (string-append name "-" version ".tar.gz"))
            (sha256
             (base32
              "1bjijdfqhpazyifx1qda7scj7dry1azhjrnl8h8zn2vqfgdmlh0q"))))
   (build-system gnu-build-system)
   (arguments
    '(#:make-flags `(,(string-append "prefix=" (assoc-ref %outputs "out")))
      #:parallel-build? #f
      #:tests? #f ; no check target
      #:phases
      (modify-phases %standard-phases
        (replace 'configure
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (let* ((dejavu (assoc-ref inputs "font-dejavu"))
                          (freedoom (assoc-ref outputs "out"))
                          (wad-dir (string-append freedoom "/share/games/doom")))
                     ;; Replace the font-searching function in a shell
                     ;; script with a direct path to the required font.
                     ;; This is necessary because ImageMagick can only find the
                     ;; most basic fonts while in the build environment.
                     (substitute* "graphics/titlepic/create_caption"
                       (("font=\\$\\(find_font.*$")
                        (string-append
                         "font=" dejavu
                         "/share/fonts/truetype/DejaVuSansCondensed-Bold.ttf\n")))
                     ;; Make icon creation reproducible.
                     (substitute* "dist/Makefile"
                       (("freedm.png")
                        "-define png:exclude-chunks=date freedm.png")
                       (("freedoom1.png")
                        "-define png:exclude-chunks=date freedoom1.png")
                       (("freedoom2.png")
                        "-define png:exclude-chunks=date freedoom2.png"))
                     ;; Make sure that the install scripts know where to find
                     ;; the appropriate WAD files.
                     (substitute* "dist/freedoom"
                       (("IWAD=freedm.wad")
                        (string-append "IWAD=" wad-dir "/freedm.wad"))
                       (("IWAD=freedoom1.wad")
                        (string-append "IWAD=" wad-dir "/freedoom1.wad"))
                       (("IWAD=freedoom2.wad")
                        (string-append "IWAD=" wad-dir "/freedoom2.wad")))
                     #t))))))
   (native-inputs
    `(("asciidoc" ,asciidoc)
      ("deutex" ,deutex)
      ("font-dejavu" ,font-dejavu)
      ("imagemagick" ,imagemagick)
      ("python" ,python-2)))
   (inputs
    `(("prboom-plus" ,prboom-plus)))
   (home-page "https://freedoom.github.io/")
   (synopsis "Free content game based on the Doom engine")
   (native-search-paths
    (list (search-path-specification
           (variable "DOOMWADDIR")
           (files '("share/games/doom")))
          (search-path-specification
           (variable "DOOMWADPATH")
           (files '("share/games/doom")))))
   (description
    "The Freedoom project aims to create a complete free content first person
shooter game.  Freedoom by itself is just the raw material for a game: it must
be paired with a compatible game engine (such as @code{prboom-plus}) to be
played.  Freedoom complements the Doom engine with free levels, artwork, sound
effects and music to make a completely free game.")
   (license license:bsd-3)))

(define-public golly
  (package
    (name "golly")
    (version "3.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/golly/golly/golly-"
                                  version "/golly-" version
                                  "-src.tar.gz"))
              (sha256
               (base32
                "0dn74k3rylhx023n047lz4z6qrqijfcxi0b6jryqklhmm2n532f7"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list "CC=gcc"
                          (string-append "GOLLYDIR="
                                         (assoc-ref %outputs "out")
                                         "/share/golly"))
       #:tests? #f ; no check target
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs #:allow-other-keys)
             ;; For some reason, setting the PYTHON_SHLIB make flag doesn't
             ;; properly set the path to the Python shared library. This
             ;; substitution acheives the same end by different means.
             (substitute* "gui-wx/wxprefs.cpp"
               (("pythonlib = wxT\\(STRINGIFY\\(PYTHON_SHLIB\\)\\)")
                (string-append "pythonlib = \""
                               (assoc-ref inputs "python")
                               "/lib/libpython-2.7.so\"")))
             #t))
         (replace 'build
           (lambda* (#:key make-flags outputs #:allow-other-keys)
             (with-directory-excursion "gui-wx"
               (apply invoke `("make" ,@make-flags "-f" "makefile-gtk")))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (doc (string-append out "/share/doc/golly"))
                    (pixmaps (string-append out "/share/pixmaps"))
                    (share (string-append out "/share/golly")))
               (for-each (lambda (binary)
                           (install-file binary bin))
                         '("bgolly" "golly"))
               (for-each (lambda (document)
                           (install-file
                            (string-append "docs/" document ".html")
                            doc))
                         '("License" "ReadMe" "ToDo"))
               (install-file "gui-wx/icons/appicon.xpm" pixmaps)
               (for-each (lambda (folder)
                           (copy-recursively
                            folder
                            (string-append share "/" folder)))
                         '("Help" "Patterns" "Rules" "Scripts")))
             #t)))))
    (native-inputs
     `(("lua" ,lua)))
    (inputs
     `(("glu" ,glu)
       ("mesa" ,mesa)
       ("python" ,python-2)
       ("wxwidgets" ,wxwidgets-gtk2)
       ("zlib" ,zlib)))
    (home-page "http://golly.sourceforge.net/")
    (synopsis "Software for exploring cellular automata")
    (description
     "Golly simulates Conway's Game of Life and many other types of cellular
automata.  The following features are available:
@enumerate
@item Support for bounded and unbounded universes, with cells of up to 256
  states.
@item Support for multiple algorithms, including Bill Gosper's Hashlife
  algorithm.
@item Loading patterns from BMP, PNG, GIF and TIFF image files.
@item Reading RLE, macrocell, Life 1.05/1.06, dblife and MCell files.
@item Scriptable via Lua or Python.
@item Extracting patterns, rules and scripts from zip files.
@item Downloading patterns, rules and scripts from online archives.
@item Pasting patterns from the clipboard.
@item Unlimited undo/redo.
@item Configurable keyboard shortcuts.
@item Auto fit option to keep patterns within the view.
@end enumerate")
    (license license:gpl2+)))

(define-public meandmyshadow
  (package
    (name "meandmyshadow")
    (version "0.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/meandmyshadow/"
                                  version "/meandmyshadow-" version
                                  "-src.tar.gz"))
              (sha256
               (base32
                "1dpb7s32b2psj5w3nr5kqibib8nndi86mw8gxp4hmxwrfiisf86d"))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f ; there are no tests
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-sdl'paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "cmake/Modules/FindSDL_gfx.cmake"
               (("/usr/local/include/SDL")
                (string-append (assoc-ref inputs "sdl")
                               "/include/SDL")))
             ;; Because SDL provides lib/libX11.so.6 we need to explicitly
             ;; link with libX11, even though we're using the GL backend.
             (substitute* "CMakeLists.txt"
               (("\\$\\{X11_LIBRARIES\\}") "-lX11"))
             )))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("sdl" ,(sdl-union (list sdl
                                sdl-image
                                sdl-gfx
                                sdl-mixer
                                sdl-ttf)))
       ("libx11" ,libx11) ; needed by sdl's libX11
       ("libarchive" ,libarchive)
       ("openssl" ,openssl)
       ("mesa" ,mesa)
       ("glu" ,glu)
       ("curl" ,curl)))
    (home-page "http://meandmyshadow.sourceforge.net/")
    (synopsis "Puzzle/platform game")
    (description "Me and My Shadow is a puzzle/platform game in which you try
to reach the exit by solving puzzles.  Spikes, moving blocks, fragile blocks
and much more stand between you and the exit.  Record your moves and let your
shadow mimic them to reach blocks you couldn't reach alone.")
    (license license:gpl3+)))

(define-public knights
  (package
    (name "knights")
    (version "025")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://www.knightsgame.org.uk/files/knights_"
                                  version "_src.tar.gz"))
              (sha256
               (base32
                "18vp2ygvn0s0jz8rm585jqf6hjqkam1ximq81k0r9hpmfj7wb88f"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags
       (list (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         ;; No configure script.
         (delete 'configure))
       #:tests? #f)) ;; No check target.
    (inputs
     `(("boost" ,boost)
       ("sdl-union" ,(sdl-union (list sdl sdl-image sdl-mixer)))
       ("freetype" ,freetype)
       ("fontconfig" ,fontconfig)
       ("curl" ,curl)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "http://www.knightsgame.org.uk/")
    (synopsis "Multiplayer dungeon game involving knights and quests")
    (description "Knights is a multiplayer game involving several knights who
must run around a dungeon and complete various quests.  Each game revolves
around a quest – for example, you might have to find some items and carry them
back to your starting point.  This may sound easy, but as there are only
enough items in the dungeon for one player to win, you may end up having to
kill your opponents to get their stuff!  Other quests involve escaping from
the dungeon, fighting a duel to the death against the enemy knights, or
destroying an ancient book using a special wand.")
    ;; This package includes modified sources of lua (X11), enet (Expat), and
    ;; guichan (BSD-3).  The "Coercri" library is released under the Boost
    ;; license.  The whole package is released under GPLv3+.
    (license license:gpl3+)))

(define-public gnubg
  (package
    (name "gnubg")
    (version "1.02")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://files.gnubg.org/media/sources/gnubg-release-"
                           version ".000-sources." "tar.gz"))
       (sha256
        (base32
         "015mvjk2iw1cg1kxwxfnvp2rxb9cylf6yc39i30fdy414k07zkky"))))
    (build-system gnu-build-system)
    (inputs `(("glib" ,glib)
              ("readline" ,readline)
              ("gtk+" ,gtk+-2)
              ("mesa" ,mesa)
              ("glu" ,glu)
              ("gtkglext" ,gtkglext)
              ("sqlite" ,sqlite)
              ("libcanberra" ,libcanberra)))
    (native-inputs `(("python-2" ,python-2)
                     ("pkg-config" ,pkg-config)))
    (home-page "http://gnubg.org")
    (synopsis "Backgammon game")
    (description "The GNU backgammon application can be used for playing, analyzing and
teaching the game.  It has an advanced evaluation engine based on artificial
neural networks suitable for both beginners and advanced players.  In
addition to a command-line interface, it also features an attractive, 3D
representation of the playing board.")
    (license license:gpl3+)))

(define-public gnubik
  (package
    (name "gnubik")
    (version "2.4.3")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/gnubik/gnubik-"
                          version ".tar.gz"))
      (sha256
       (base32
        "1vlf924mq8hg93bsjj0rzvs0crc6psmlxyc6zn0fr7msnmpx6gib"))))
    (build-system gnu-build-system)
    (inputs `(("gtk+" ,gtk+-2)
              ("mesa" ,mesa)
              ("glu" ,glu)
              ("libx11" ,libx11)
              ("guile" ,guile-2.0)
              ("gtkglext" ,gtkglext)))
    (native-inputs `(("gettext" ,gettext-minimal)
                     ("pkg-config" ,pkg-config)))
    (home-page "https://www.gnu.org/software/gnubik/")
    (synopsis "3d Rubik's cube game")
    (description
     "GNUbik is a puzzle game in which you must manipulate a cube to make
each of its faces have a uniform color.  The game is customizable, allowing
you to set the size of the cube (the default is 3x3) or to change the colors.
You may even apply photos to the faces instead of colors.  The game is
scriptable with Guile.")
    (license license:gpl3+)))

(define-public gnushogi
  (package
    (name "gnushogi")
    (version "1.4.2")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/gnushogi/gnushogi-"
                          version ".tar.gz"))
      (sha256
       (base32
        "0a9bsl2nbnb138lq0h14jfc5xvz7hpb2bcsj4mjn6g1hcsl4ik0y"))))
    (arguments `(#:tests? #f)) ;; No check target.
    (build-system gnu-build-system)
    (home-page "https://www.gnu.org/software/gnushogi/")
    (synopsis "The game of Shogi (Japanese chess)")
    (description  "GNU Shogi is a program that plays the game Shogi (Japanese
Chess).  It is similar to standard chess but this variant is far more complicated.")
    (license license:gpl3+)))

(define-public ltris
  (package
    (name "ltris")
    (version "1.0.19")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://prdownloads.sourceforge.net/lgames/"
                           name "-" version ".tar.gz"))
       (sha256
        (base32
         "1895wv1fqklrj4apkz47rnkcfhfav7zjknskw6p0886j35vrwslg"))))
    (build-system gnu-build-system)
    (arguments
     '(;; The code in LTris uses traditional GNU semantics for inline functions
       #:configure-flags '("CFLAGS=-fgnu89-inline")
       #:phases
       (modify-phases %standard-phases
         (add-after 'set-paths 'set-sdl-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "CPATH"
                     (string-append (assoc-ref inputs "sdl-union")
                                    "/include/SDL"))
             #t)))))
    (inputs
     `(("sdl-union" ,(sdl-union (list sdl sdl-mixer)))))
    (home-page "http://lgames.sourceforge.net/LTris/")
    (synopsis "Tetris clone based on the SDL library")
    (description
     "LTris is a tetris clone: differently shaped blocks are falling down the
rectangular playing field and can be moved sideways or rotated by 90 degree
units with the aim of building lines without gaps which then disappear (causing
any block above the deleted line to fall down).  LTris has three game modes: In
Classic you play until the stack of blocks reaches the top of the playing field
and no new blocks can enter.  In Figures the playing field is reset to a new
figure each level and later on tiles and lines suddenly appear.  In Multiplayer
up to three players (either human or CPU) compete with each other sending
removed lines to all opponents.  There is also a Demo mode in which you can
watch your CPU playing while enjoying a cup of tea!")
    (license license:gpl2+)))

(define-public prboom-plus
  (package
   (name "prboom-plus")
   (version "2.5.1.4")
   (source (origin
            (method url-fetch)
            (uri (string-append "mirror://sourceforge/" name "/" name "/"
                                version "/" name "-" version ".tar.gz"))
            (sha256
             (base32
              "151v6nign86m1a2vqz27krsccpc9m4d1jax4y43v2fa82wfj9qp0"))
            (modules '((guix build utils)))
            (snippet
             '(substitute* "src/version.c"
                           (("__DATE__") "")
                           (("__TIME__") "")))))
   (build-system gnu-build-system)
   (arguments
    '(#:configure-flags '("--disable-cpu-opt")
      #:make-flags `(,(string-append "gamesdir="
                                     (assoc-ref %outputs "out") "/bin"))
      #:phases
      (modify-phases %standard-phases
        (add-after 'set-paths 'set-sdl'paths
          (lambda* (#:key inputs #:allow-other-keys)
            (setenv "CPATH"
                    (string-append (assoc-ref inputs "sdl-union")
                                   "/include/SDL"))
            #t)))))
   (inputs
    `(("fluidsynth" ,fluidsynth)
      ("glu" ,glu)
      ("libmad" ,libmad)
      ("libpng" ,libpng)
      ("libvorbis" ,libvorbis)
      ("pcre" ,pcre)
      ("portmidi" ,portmidi)
      ("sdl-union" ,(sdl-union (list sdl sdl-image sdl-mixer sdl-net)))))
   (home-page "http://prboom-plus.sourceforge.net/")
   (synopsis "Version of the classic 3D shoot'em'up game Doom")
   (description
    "PrBoom+ is a Doom source port developed from the original PrBoom project.")
   (license license:gpl2+)))

(define-public retux
  (package
    (name "retux")
    (version "1.3.5")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://savannah/retux/"
                                  (version-major+minor version) "/retux-"
                                  version "-src.tar.gz"))
              (sha256
               (base32
                "1pcrh3z16fl412r3k7xccrgika19ahb1xh90jihgl8yy7zza2i6p"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; no check target
       #:phases
       (modify-phases %standard-phases
         ;; no setup.py script
         (delete 'build)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out    (assoc-ref outputs "out"))
                    (bin    (string-append out "/bin"))
                    (data   (string-append out "/share/retux"))
                    (doc    (string-append out "/share/doc/retux")))
               (mkdir-p bin)

               (substitute* "retux.py"
                 ;; Use the correct data directory.
                 (("os\\.path\\.join\\(os\\.path\\.dirname\\(__file__\\), \"data\"\\),")
                  (string-append "\"" data "\","))
                 ;; Use Python 3 so the patch-shebangs phase works properly.
                 ((".*python2.*") "#!/usr/bin/python3"))

               (copy-file "retux.py" (string-append bin "/retux"))

               (copy-recursively "data" data)

               (install-file "COPYING" doc)))))))
    (inputs
     `(("python-sge-pygame" ,python-sge-pygame)
       ("python-six" ,python-six)
       ("python-xsge" ,python-xsge)))
    (home-page "http://retux.nongnu.org")
    (synopsis "Action platformer game")
    (description
     "ReTux is an action platformer loosely inspired by the Mario games,
utilizing the art assets from the @code{SuperTux} project.")
    ;; GPL version 3 or later is the license for the code and some art.
    ;; The rest of the licenses are for the art exclusively, as listed in
    ;; data/LICENSES.
    (license (list license:cc0
                   license:cc-by3.0
                   license:cc-by-sa3.0
                   license:cc-by-sa4.0
                   license:gpl2+
                   license:gpl3+))))

(define-public roguebox-adventures
  (let ((commit "19a2c340b34d5b4e7cc89118c7aedc058babbd93")
        (revision "1"))
      (package
        (name "roguebox-adventures")
        (version (git-version "2.1.2" revision commit))
        (source
         (origin
           (method git-fetch)
           (uri
            (git-reference
             (url "https://git.postactiv.com/themightyglider/RogueBoxAdventures.git")
                 (commit commit)))
           (file-name (git-file-name name version))
           (sha256
            (base32
             "0afmg8fjdcs3sqdp5rc7irgr7riil8jwysfjn1imfxslf1wcx5ah"))))
        (build-system python-build-system)
        (arguments
         '(#:tests? #f ; no check target
           #:phases
           (modify-phases %standard-phases
             ;; no setup.py script
             (replace 'build
               (lambda* (#:key outputs #:allow-other-keys)
                 (let* ((out (assoc-ref outputs "out"))
                        (data (string-append
                               out "/share/games/roguebox-adventures")))
                   ;; Use the correct data directory.
                   (substitute* '("main.py" "LIB/getch.py" "LIB/getch_gcwz.py")
                     (("basic_path + os\\.sep + 'DATA'")
                      (string-append "'" data "'"))
                     (("^basic_path.*$")
                      (string-append "basic_path ='" data "'\n")))
                   (substitute* "LIB/gra_files.py"
                     (("basic_path = b_path\\.replace\\('/LIB',''\\)")
                      (string-append "basic_path ='" data "'\n")))

                   ;; The game must save in the user's home directory because
                   ;; the store is read-only.
                   (substitute* "main.py"
                     (("home_save = False") "home_save = True")
                     (("'icon_small.png'")
                      (string-append "'" data "/icon_small.png'"))))
                 #t))
             (replace 'install
               (lambda* (#:key outputs #:allow-other-keys)
                 (let* ((out (assoc-ref outputs "out"))
                        (bin (string-append out "/bin"))
                        (data (string-append
                               out "/share/games/roguebox-adventures"))
                        (doc (string-append
                              out "/share/doc/roguebox-adventures")))
                   (mkdir-p bin)
                   (mkdir-p doc)
                   (copy-file "main.py"
                              (string-append bin "/roguebox-adventures"))
                   (chmod (string-append bin "/roguebox-adventures") #o555)

                   (for-each (lambda (file)
                               (copy-recursively file
                                                 (string-append data "/" file)))
                             '("AUDIO" "FONT" "GRAPHIC" "LIB" "LICENSE"
                               "icon_big.png" "icon_small.png"))

                   (copy-recursively "DOC" doc)

                   (wrap-program (string-append bin "/roguebox-adventures")
                     `("PYTHONPATH" ":" prefix (,(string-append data "/LIB")))))
                 #t)))))
        (inputs
         `(("python-pygame" ,python-pygame)
           ("python-tmx" ,python-tmx)))
        (home-page "https://rogueboxadventures.tuxfamily.org")
        (synopsis "A classical roguelike/sandbox game")
        (description
         "RogueBox Adventures is a graphical roguelike with strong influences
from sandbox games like Minecraft or Terraria.  The main idea of RogueBox
Adventures is to offer the player a kind of roguelike toy-world.  This world
can be explored and changed freely.")
        ;; The GPL3+ is for code, the rest are for art.
        (license (list license:cc0
                       license:cc-by3.0
                       license:gpl3+
                       license:silofl1.1)))))

(define-public xshogi
  (package
    (name "xshogi")
    (version "1.4.2")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/gnushogi/xshogi-"
                          version ".tar.gz"))
      (sha256
       (base32
        "1dns0nhymak44by18sv48m4xb2skiwbi2i3nb9hl6w9iwd2i2brf"))))
    (build-system gnu-build-system)
    (inputs
     `(("libxaw" ,libxaw)
       ("libxt" ,libxt)))
    (home-page "https://www.gnu.org/software/gnushogi/")
    (synopsis "User interface for gnushogi")
    (description  "A graphical user interface for the package @code{gnushogi}.")
    ;; Contains a copy of GPLv3 but the licence notices simply
    ;; state "GNU General Public Licence" without specifying a version.
    (license license:gpl1+)))

(define-public abbaye
  (package
    (name "abbaye")
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/nevat/abbayedesmorts-gpl/"
                           "archive/v" version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1a67b0hq6271dd7pvwndjq29cwn2n8gawwz17xafa3k1hrhf8vw3"))
       (modules '((guix build utils)))
       (snippet
        ;; Unbundle fonts.
        '(delete-file-recursively "fonts"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags '("CC=gcc")
       #:phases (modify-phases %standard-phases
                  (add-after 'set-paths 'set-sdl-paths
                    (lambda* (#:key inputs #:allow-other-keys)
                      (setenv "CPATH"
                              (string-append (assoc-ref inputs "sdl-union")
                                             "/include/SDL"))))
                  (add-after 'patch-source-shebangs 'patch-makefile
                    (lambda* (#:key outputs #:allow-other-keys)
                      ;; Replace /usr with package output directory.
                      (substitute* "Makefile"
                        (("/usr") (assoc-ref outputs "out")))))
                  (add-before 'install 'make-install-dirs
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((prefix (assoc-ref outputs "out")))
                        ;; Create directories that the makefile assumes exist.
                        (mkdir-p (string-append prefix "/bin"))
                        (mkdir-p (string-append prefix "/share/applications"))
                        (mkdir-p (string-append prefix "/share/pixmaps")))))
                  ;; No configure script.
                  (delete 'configure))
       #:tests? #f)) ;; No check target.
    (native-inputs `(("pkg-config" ,pkg-config)))
    (inputs `(("sdl-union" ,(sdl-union (list sdl2 sdl2-image sdl2-mixer)))))
    (home-page "https://github.com/nevat/abbayedesmorts-gpl")
    (synopsis "GNU/Linux port of the indie game \"l'Abbaye des Morts\"")
    (description "L'Abbaye des Morts is a 2D platform game set in 13th century
France.  The Cathars, who preach about good Christian beliefs, were being
expelled by the Catholic Church out of the Languedoc region in France.  One of
them, called Jean Raymond, found an old church in which to hide, not knowing
that beneath its ruins lay buried an ancient evil.")
    (license license:gpl3)))

(define-public angband
  (package
    (name "angband")
    (version "4.0.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://rephial.org/downloads/4.0/"
                           "angband-" version ".tar.gz"))
       (sha256
        (base32
         "0lpq2kms7hp421vrasx2bkkn9w08kr581ldwik3v0hlq6h7rlxhd"))
       (modules '((guix build utils)))
       (snippet
        ;; So, some of the sounds/graphics/tilesets are under different
        ;; licenses... some of them even nonfree!  This is a console-only
        ;; version of this package so we just remove them.
        ;; In the future, if someone tries to make a graphical variant of
        ;; this package, they can deal with that mess themselves. :)
        '(begin
           (for-each
            (lambda (subdir)
              (let ((lib-subdir (string-append "lib/" subdir)))
                (delete-file-recursively lib-subdir)))
            '("fonts" "icons" "sounds" "tiles"))
           (substitute* "lib/Makefile"
             ;; And don't try to invoke makefiles in the directories we removed
             (("gamedata customize help screens fonts tiles sounds icons user")
              "gamedata customize help screens user"))))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                                 ;no check target
       #:configure-flags (list (string-append "--bindir=" %output "/bin"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'autogen.sh
           (lambda _
             (substitute* "acinclude.m4"
               (("ncursesw5-config") "ncursesw6-config"))
             (zero? (system* "sh" "autogen.sh")))))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)))
    (inputs `(("ncurses" ,ncurses)))
    (home-page "http://rephial.org/")
    (synopsis "Dungeon exploration roguelike")
    (description "Angband is a Classic dungeon exploration roguelike.  Explore
the depths below Angband, seeking riches, fighting monsters, and preparing to
fight Morgoth, the Lord of Darkness.")
    (license license:gpl2)))

(define-public pingus
  (package
    (name "pingus")
    (version "0.7.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/Pingus/pingus/archive/v"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0r9v6as5vi7skvvy7b0fcaimhdlzmik64pyy68plgljhsghqkkf4"))
       (patches (search-patches "pingus-sdl-libs-config.patch"))))
    (build-system gnu-build-system)
    (native-inputs `(("pkg-config" ,pkg-config)
                     ("scons-python2" ,scons-python2)))
    (inputs `(("sdl" ,sdl)
              ("sdl-image" ,sdl-image)
              ("sdl-mixer" ,sdl-mixer)
              ("mesa" ,mesa)
              ("glu" ,glu)
              ("libpng" ,libpng)
              ("boost" ,boost)))
    (arguments
     '(#:make-flags (list (string-append "PREFIX=" %output))
       #:tests? #f                      ; no check target
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)))) ; no configure script
    (home-page "http://pingus.seul.org/welcome.html")
    (synopsis "Lemmings clone")
    (description
     "Pingus is a free Lemmings-like puzzle game in which the player takes
command of a bunch of small animals and has to guide them through levels.
Since the animals walk on their own, the player can only influence them by
giving them commands, like build a bridge, dig a hole, or redirect all animals
in the other direction.  Multiple such commands are necessary to reach the
level's exit.  The game is presented in a 2D side view.")
    ;; Some source files are under bsd-3 and gpl2+ licenses.
    (license license:gpl3+)))

(define-public talkfilters
  (package
    (name "talkfilters")
    (version "2.3.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://www.hyperrealm.com/" name "/"
                           name  "-" version  ".tar.gz"))
       (sha256
        (base32 "19nc5vq4bnkjvhk8srqddzhcs93jyvpm9r6lzjzwc1mgf08yg0a6"))))
    (build-system gnu-build-system)
    (home-page "https://www.gnu.org/software/talkfilters/")
    (synopsis "Convert English text to humorous dialects")
    (description "The GNU Talk Filters are programs that convert English text
into stereotyped or otherwise humorous dialects.  The filters are provided as
a C library, so they can easily be integrated into other programs.")
    (license license:gpl2+)))

(define-public cmatrix
  (package
    (name "cmatrix")
    (version "1.2a")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://www.asty.org/cmatrix/dist/cmatrix-" version
                           ".tar.gz"))
       (sha256
        (base32
         "0k06fw2n8nzp1pcdynhajp5prba03gfgsbj91bknyjr5xb5fd9hz"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             ;; This old ‘configure’ script doesn't support
             ;; variables passed as arguments.
             (let ((out (assoc-ref outputs "out")))
               (setenv "CONFIG_SHELL" (which "bash"))
               (zero?
                (system* "./configure"
                         (string-append "--prefix=" out)))))))))
    (inputs `(("ncurses" ,ncurses)))
    (home-page "http://www.asty.org/cmatrix")
    (synopsis "Simulate the display from \"The Matrix\"")
    (description "CMatrix simulates the display from \"The Matrix\" and is
based on the screensaver from the movie's website.  It works with terminal
settings up to 132x300 and can scroll lines all at the same rate or
asynchronously and at a user-defined speed.")
    (license license:gpl2+)))

(define-public chess
  (package
    (name "chess")
    (version "6.2.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnu/chess/gnuchess-" version
                           ".tar.gz"))
       (sha256
        (base32
         "00j8s0npgfdi41a0mr5w9qbdxagdk2v41lcr42rwl1jp6miyk6cs"))))
    (build-system gnu-build-system)
    (home-page "https://www.gnu.org/software/chess/")
    (synopsis "Full chess implementation")
    (description "GNU Chess is a chess engine.  It allows you to compete
against the computer in a game of chess, either through the default terminal
interface or via an external visual interface such as GNU XBoard.")
    (license license:gpl3+)))

(define freedink-engine
  (package
    (name "freedink-engine")
    (version "108.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/freedink/freedink-" version
                                  ".tar.gz"))
              (sha256
               (base32
                "08c51imfjfcydm7h0va09z8qfw5nc837bi2x754ni2z737hb5kw2"))))
    (build-system gnu-build-system)
    (arguments `(#:configure-flags '("--disable-embedded-resources")))
    (native-inputs `(("gettext" ,gettext-minimal)
                     ("pkg-config" ,pkg-config)))
    (inputs `(("sdl" ,sdl)
              ("sdl-image" ,sdl-image)
              ("sdl-mixer" ,sdl-mixer)
              ("sdl-ttf" ,sdl-ttf)
              ("sdl-gfx" ,sdl-gfx)
              ("fontconfig" ,fontconfig)
              ("check" ,check)))
    (home-page "https://www.gnu.org/software/freedink/")
    (synopsis "Twisted adventures of young pig farmer Dink Smallwood")
    (description
     "GNU FreeDink is a free and portable re-implementation of the engine
for the role-playing game Dink Smallwood.  It supports not only the original
game data files but it also supports user-produced game mods or \"D-Mods\".
To that extent, it also includes a front-end for managing all of your D-Mods.")
    (license license:gpl3+)))

(define freedink-data
  (package
    (name "freedink-data")
    (version "1.08.20170401")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/freedink/freedink-data-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1zx7qywibhznj7bnz217404scr8dfh0xj24xjihnda5iapzz7lz8"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; no configure script
         (delete 'check))               ; no tests
       #:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out")))))
    (home-page "https://www.gnu.org/software/freedink/")
    (synopsis "Game data for GNU Freedink")
    (description
     "This package contains the game data of GNU Freedink.")
    (license license:gpl3+)))

;; TODO: Add freedink-dfarc when there's a wxWidgets package.

(define-public freedink
  ;; This is a wrapper that tells the engine where to find the data.
  (package (inherit freedink-engine)
    (name "freedink")
    (build-system trivial-build-system)
    (arguments
     '(#:builder (begin
                   (use-modules (guix build utils))

                   (let* ((output     (assoc-ref %outputs "out"))
                          (bin        (string-append output "/bin"))
                          (executable (string-append bin "/freedink")))
                     (mkdir-p bin)
                     (call-with-output-file executable
                       (lambda (port)
                         (format port "#!~a/bin/sh
exec ~a/bin/freedink -refdir ~a/share/dink\n"
                                 (assoc-ref %build-inputs "bash")
                                 (assoc-ref %build-inputs "engine")
                                 (assoc-ref %build-inputs "data"))
                         (chmod port #o777)))))
       #:modules ((guix build utils))))
    (inputs `(("engine" ,freedink-engine)
              ("data" ,freedink-data)
              ("bash" ,bash)))
    (native-inputs '())))

(define-public xboard
  (package
    (name "xboard")
    (version "4.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnu/xboard/xboard-" version
                           ".tar.gz"))
       (sha256
        (base32
         "1mkh36xnnacnz9r00b5f9ld9309k32jv6mcavklbdnca8bl56bib"))))
    (build-system gnu-build-system)
    (inputs
     `(("gtk+" ,gtk+-2)
       ("librsvg" ,librsvg)))
    (native-inputs
     `(("texinfo" ,texinfo)
       ("pkg-config" ,pkg-config)))
    (home-page "https://www.gnu.org/software/xboard/")
    (synopsis "Graphical user interface for chess programs")
    (description "GNU XBoard is a graphical board for all varieties of chess,
including international chess, xiangqi (Chinese chess), shogi (Japanese chess)
and Makruk.  Several lesser-known variants are also supported.  It presents a
fully interactive graphical interface and it can load and save games in the
Portable Game Notation.")
    (license license:gpl3+)))


(define-public xboing
  (package
    (name "xboing")
    (version "2.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://www.techrescue.org/xboing/xboing"
                           version ".tar.gz"))
       (sha256
        (base32 "16m2si8wmshxpifk861vhpqviqxgcg8bxj6wfw8hpnm4r2w9q0b7"))
       (patches (search-patches "xboing-CVE-2004-0149.patch"))))
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)

             (substitute* "Imakefile"
               (("XPMINCLUDE[\t ]*= -I/usr/X11/include/X11")
                (string-append "XPMINCLUDE = -I"
                               (assoc-ref %build-inputs "libxpm")
                               "/include/X11")))

             (substitute* "Imakefile"
               (("XBOING_DIR = \\.") "XBOING_DIR=$(PROJECTROOT)"))

             ;; FIXME: HIGH_SCORE_FILE should be set to somewhere writeable

             (zero? (system* "xmkmf" "-a"
                             (string-append "-DProjectRoot="
                                            (assoc-ref outputs "out"))))))
        (replace 'install
          (lambda* (#:key outputs #:allow-other-keys)
            (and
             (zero? (system* "make" "install.man"))
             (zero? (system* "make" "install"))))))))
    (inputs `(("libx11" ,libx11)
              ("libxext" ,libxext)
              ("libxpm" ,libxpm)))
    (native-inputs `(("imake" ,imake)
                     ("inetutils" ,inetutils)
                     ("makedepend" ,makedepend)))
    (build-system gnu-build-system)
    (home-page "http://www.techrescue.org/xboing")
    (synopsis "Ball and paddle game")
    (description "XBoing is a blockout type game where you have a paddle which
you control to bounce a ball around the game zone destroying blocks with a
proton ball.  Each block carries a different point value.  The more blocks you
destroy, the better your score.  The person with the highest score wins.")
    (license (license:x11-style "file://COPYING"
                                "Very similar to the X11 licence."))))

(define-public gtypist
  (package
    (name "gtypist")
    (version "2.9.5")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/gtypist/gtypist-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "0xzrkkmj0b1dw3yr0m9hml2y634cc4h61im6zwcq57s7285z8fn1"))
              (modules '((guix build utils)))
              (snippet
               ;; We do not provide `ncurses.h' within an `ncursesw'
               ;; sub-directory, so patch the source accordingly.  See
               ;; <http://bugs.gnu.org/19018>.
               '(for-each (lambda (file)
                            (substitute* file
                              (("ncursesw/ncurses.h")
                               "ncurses.h")))
                          (find-files "." "configure$|\\.c$")))))
    (build-system gnu-build-system)
    (inputs `(("ncurses" ,ncurses)
              ("perl" ,perl)))
    (home-page "https://www.gnu.org/software/gtypist/")
    (synopsis "Typing tutor")
    (description
     "GNU Typist is a universal typing tutor.  It can be used to learn and
practice touch-typing.  Several tutorials are included; in addition to
tutorials for the standard QWERTY layout, there are also tutorials for the
alternative layouts Dvorak and Colemak, as well as for the numpad.  Tutorials
are primarily in English, however some in other languages are provided.")
    (license license:gpl3+)))

(define-public irrlicht
  (package
    (name "irrlicht")
    (version "1.8.4")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://sourceforge/irrlicht/Irrlicht%20SDK/"
                    (version-major+minor version)
                    "/" version "/irrlicht-" version ".zip"))
              (sha256
               (base32
                "0cz4z4dwrv5ypl19ll67wl6jjpy5k6ly4vr042w4br88qq5jhazl"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-build-env
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* "Makefile"
                 (("INSTALL_DIR = /usr/local/lib")
                  (string-append "INSTALL_DIR = " out "/lib")))
               ;; The Makefile assumes these directories exist.
               (mkdir-p (string-append out "/lib"))
               (mkdir-p (string-append out "/include")))))
         (replace 'unpack
           (lambda* (#:key source #:allow-other-keys)
             (and (zero? (system* "unzip" source))
                  ;; The actual source is buried a few directories deep.
                  (chdir (string-append "irrlicht-" ,version
                                        "/source/Irrlicht/")))))
         (delete 'configure))           ; no configure script
       #:tests? #f                      ; no check target
       #:make-flags '("CC=gcc" "sharedlib")))
    (native-inputs
     `(("unzip" ,unzip)))
    (inputs
     `(("mesa" ,mesa)
       ("glu" ,glu)))
    (synopsis "3D game engine written in C++")
    (description
     "The Irrlicht Engine is a high performance realtime 3D engine written in
C++.  Features include an OpenGL renderer, extensible materials, scene graph
management, character animation, particle and other special effects, support
for common mesh file formats, and collision detection.")
    (home-page "http://irrlicht.sourceforge.net/")
    (license license:zlib)))

(define-public mars
  ;; The latest release on SourceForge relies on an unreleased version of SFML
  ;; with a different API, so we take the latest version from the official
  ;; repository on Github.
  (let ((commit   "c855d044094a1d92317e38935d81ba938946132e")
        (revision "1"))
    (package
      (name "mars")
      (version (string-append "0.7.5." revision "." (string-take commit 7) ))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/thelaui/M.A.R.S..git")
                      (commit commit)))
                (file-name (string-append name "-" version))
                (sha256
                 (base32
                  "1r4c5gap1z2zsv4yjd34qriqkxaq4lb4rykapyzkkdf4g36lc3nh"))
                (patches (search-patches "mars-sfml-2.3.patch"
                                         "mars-install.patch"))))
      (build-system cmake-build-system)
      (arguments
       `(#:tests? #f        ; There are no tests
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-install-path
            (lambda _
              (substitute* "src/CMakeLists.txt"
                (("\\$\\{CMAKE_INSTALL_PREFIX\\}/games")
                 "${CMAKE_INSTALL_PREFIX}/bin"))
              #t))
           (add-after 'unpack 'fix-data-path
            (lambda* (#:key outputs #:allow-other-keys)
              (substitute* "src/System/settings.cpp"
                (("C_dataPath = \"./data/\";")
                 (string-append "C_dataPath = \""
                                (assoc-ref outputs "out")
                                "/share/games/marsshooter/\";")))
              #t)))))
      (inputs
       `(("mesa" ,mesa)
         ("fribidi" ,fribidi)
         ("taglib" ,taglib)
         ("sfml" ,sfml)))
      (home-page "http://marsshooter.org")
      (synopsis "2D space shooter")
      (description
       "M.A.R.S. is a 2D space shooter with pretty visual effects and
attractive physics.  Players can battle each other or computer controlled
enemies in different game modes such as space ball, death match, team death
match, cannon keep, and grave-itation pit.")
      (license license:gpl3+))))

(define minetest-data
  (package
    (name "minetest-data")
    (version "0.4.16")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/minetest/minetest_game/archive/"
                    version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0nibpm600rbv9dg1zgcsl5grlbqx0b5l6cg1lp6sqkwvjialb4ga"))))
    (build-system trivial-build-system)
    (native-inputs
     `(("source" ,source)
       ("tar" ,tar)
       ("gzip" ,(@ (gnu packages compression) gzip))))
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((tar (string-append (assoc-ref %build-inputs "tar")
                                             "/bin/tar"))
                         (install-dir (string-append
                                       %output
                                       "/share/minetest/games/minetest_game"))
                         (path (string-append (assoc-ref %build-inputs
                                                         "gzip")
                                              "/bin")))
                     (setenv "PATH" path)
                     (system* tar "xvf" (assoc-ref %build-inputs "source"))
                     (chdir (string-append "minetest_game-" ,version))
                     (mkdir-p install-dir)
                     (copy-recursively "." install-dir)))))
    (synopsis "Main game data for the Minetest game engine")
    (description
     "Game data for the Minetest infinite-world block sandox game.")
    (home-page "http://minetest.net")
    (license license:lgpl2.1+)))

(define-public minetest
  (package
    (name "minetest")
    (version "0.4.16")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/minetest/minetest/archive/"
                    version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0mbnf1ma4gsw9ah68ply04059xkfx5psdxwalxp78sgmx4ypkwqf"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags
         (list "-DRUN_IN_PLACE=0"
               "-DENABLE_FREETYPE=1"
               "-DENABLE_GETTEXT=1"
               (string-append "-DIRRLICHT_INCLUDE_DIR="
                              (assoc-ref %build-inputs "irrlicht")
                              "/include/irrlicht")
               (string-append "-DCURL_INCLUDE_DIR="
                              (assoc-ref %build-inputs "curl")
                              "/include/curl"))
       #:tests? #f)) ; no check target
    (native-search-paths
     (list (search-path-specification
            (variable "MINETEST_SUBGAME_PATH")
            (files '("share/minetest/games")))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("irrlicht" ,irrlicht)
       ("libpng" ,libpng)
       ("libjpeg" ,libjpeg)
       ("libxxf86vm" ,libxxf86vm)
       ("mesa" ,mesa)
       ("libogg" ,libogg)
       ("libvorbis" ,libvorbis)
       ("openal" ,openal)
       ("freetype" ,(@ (gnu packages fontutils) freetype))
       ("curl" ,curl)
       ("luajit" ,luajit)
       ("gettext" ,gettext-minimal)
       ("sqlite" ,sqlite)))
    (propagated-inputs
     `(("minetest-data" ,minetest-data)))
    (synopsis "Infinite-world block sandbox game")
    (description
     "Minetest is a sandbox construction game.  Players can create and destroy
various types of blocks in a three-dimensional open world.  This allows
forming structures in every possible creation, on multiplayer servers or as a
single player.  Mods and texture packs allow players to personalize the game
in different ways.")
    (home-page "http://minetest.net")
    (license license:lgpl2.1+)))

(define glkterm
  (package
   (name "glkterm")
   (version "1.0.4")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "http://www.ifarchive.org/if-archive/programming/"
                         "glk/implementations/glkterm-104.tar.gz"))
     (sha256
      (base32
       "0zlj9nlnkdlvgbiliczinirqygiq8ikg5hzh5vgcmnpg9pvnwga7"))))
   (build-system gnu-build-system)
   (propagated-inputs `(("ncurses" ,ncurses))) ; required by Make.glkterm
   (arguments
    '(#:tests? #f ; no check target
      #:phases
      (modify-phases %standard-phases
        (replace 'install
          (lambda* (#:key outputs #:allow-other-keys)
            (let* ((out (assoc-ref outputs "out"))
                   (inc (string-append out "/include"))
                   (lib (string-append out "/lib")))
              (for-each
               (lambda (file)
                 (install-file file inc))
               '("glk.h" "glkstart.h" "gi_blorb.h" "gi_dispa.h" "Make.glkterm"))
              (install-file "libglkterm.a" lib))
            #t))
        (delete 'configure))))          ; no configure script
   (home-page "http://www.eblong.com/zarf/glk/")
   (synopsis "Curses Implementation of the Glk API")
   (description
    "Glk defines a portable API for applications with text UIs.  It was
primarily designed for interactive fiction, but it should be suitable for many
interactive text utilities, particularly those based on a command line.
This is an implementation of the Glk library which runs in a terminal window,
using the @code{curses.h} library for screen control.")
   (license (license:fsf-free "file://README"))))

(define-public glulxe
  (package
   (name "glulxe")
   (version "0.5.4")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "http://www.ifarchive.org/if-archive/programming/"
                         "glulx/interpreters/glulxe/glulxe-054.tar.gz"))
     (sha256
      (base32
       "0vipydg6ra90yf9b3ipgppwxyb2xdhcxwvirgjy0v20wlf56zhhz"))))
   (build-system gnu-build-system)
   (inputs `(("glk" ,glkterm)))
   (arguments
    '(#:tests? #f                       ; no check target
      #:make-flags
      (let* ((glk (assoc-ref %build-inputs "glk")))
        (list (string-append "GLKINCLUDEDIR=" glk "/include")
              (string-append "GLKLIBDIR=" glk "/lib")
              (string-append "GLKMAKEFILE=" "Make.glkterm")))
      #:phases
      (modify-phases %standard-phases
        (replace 'install
          (lambda* (#:key outputs #:allow-other-keys)
            (let* ((out (assoc-ref outputs "out"))
                   (bin (string-append out "/bin")))
              (install-file "glulxe" bin))
            #t))
        (delete 'configure))))          ; no configure script
   (home-page "http://www.eblong.com/zarf/glulx/")
   (synopsis "Interpreter for Glulx VM")
   (description
    "Glulx is a 32-bit portable virtual machine intended for writing and
playing interactive fiction.  It was designed by Andrew Plotkin to relieve
some of the restrictions in the venerable Z-machine format.  This is the
reference interpreter, using the Glk API.")
   (license license:expat)))

(define-public fizmo
  (package
    (name "fizmo")
    (version "0.8.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://christoph-ender.de/fizmo/source/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "1sd988db2302r7cbfcfghbmg8ck43c6hvnlnlpb0rqxb7pm9cwyy"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       (let ((libjpeg (assoc-ref %build-inputs "libjpeg"))
             (ncurses (assoc-ref %build-inputs "ncurses")))
         (list (string-append "jpeg_CFLAGS=-I" libjpeg "/include")
               (string-append "jpeg_LIBS=-ljpeg")
               (string-append "ncursesw_CFLAGS=-I" ncurses "/include")
               (string-append "ncursesw_LIBS=-lncursesw")))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("freetype" ,freetype)
       ("libjpeg" ,libjpeg)
       ("libpng" ,libpng)
       ("libsndfile" ,libsndfile)
       ("libxml2" ,libxml2)
       ("ncurses" ,ncurses)
       ("sdl2" ,sdl2)))
    (home-page "https://christoph-ender.de/fizmo/")
    (synopsis "Z-machine interpreter")
    (description
     "Fizmo is a console-based Z-machine interpreter.  It is used to play
interactive fiction, also known as text adventures, which were implemented
either by Infocom or created using the Inform compiler.")
    (license license:bsd-3)))

(define-public gnugo
  (package
    (name "gnugo")
    (version "3.8")
    (source (origin
             (method url-fetch)
             (uri (string-append "mirror://gnu/gnugo/gnugo-" version
                                 ".tar.gz"))
             (sha256
              (base32
               "0wkahvqpzq6lzl5r49a4sd4p52frdmphnqsfdv7gdp24bykdfs6s"))))
    (build-system gnu-build-system)
    (inputs `(("readline" ,readline)))
    (synopsis "Play the game of Go")
    (description
     "GNU Go is a program that plays the game of Go, in which players
place stones on a grid to form territory or capture other stones.  While
it can be played directly from the terminal, rendered in ASCII characters,
it is also possible to play GNU Go with 3rd party graphical interfaces or
even in Emacs.  It supports the standard game storage format (SGF, Smart
Game Format) and inter-process communication format (GMP, Go Modem
Protocol).")
    (home-page "https://www.gnu.org/software/gnugo/")
    (license license:gpl3+)))

(define-public extremetuxracer
  (package
    (name "extremetuxracer")
    (version "0.7.4")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://sourceforge/extremetuxracer/releases/"
                    version "/etr-" version ".tar.xz"))
              (sha256
               (base32
                "0d2j4ybdjmimg67v2fndgahgq4fvgz3fpfb3a4l1ar75n6hy776s"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("glu" ,glu)
       ("sfml" ,sfml)))
    (synopsis "High speed arctic racing game based on Tux Racer")
    ;; Snarfed straight from Debian
    (description "Extreme Tux Racer, or etracer as it is called for short, is
a simple OpenGL racing game featuring Tux, the Linux mascot.  The goal of the
game is to slide down a snow- and ice-covered mountain as quickly as possible,
avoiding the trees and rocks that will slow you down.

Collect herrings and other goodies while sliding down the hill, but avoid fish
bones.

This game is based on the GPL version of the famous game TuxRacer.")
    (home-page "https://sourceforge.net/projects/extremetuxracer/")
    (license license:gpl2+)))

(define-public supertuxkart
  (package
    (name "supertuxkart")
    (version "0.9.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/supertuxkart/SuperTuxKart/"
                           version "/supertuxkart-" version "-src.tar.xz"))
       (sha256
        (base32
         "1c4w47ibj87lgwiqygq8qi7jiz6gklj4dwf5bs5zk15s0rqlw0fq"))
       (modules '((guix build utils)))
       (snippet
        ;; Delete bundled library sources
        '(begin
           ;; FIXME: try to unbundle enet, and angelscript
           (for-each delete-file-recursively
                     '("lib/zlib"
                       "lib/libpng"
                       "lib/jpeglib"
                       "lib/glew"
                       "lib/wiiuse"))
           (substitute* "CMakeLists.txt"
             ;; Supertuxkart uses modified versions of the Irrlicht engine
             ;; and the bullet library.  The developers gave an explanation here:
             ;; http://forum.freegamedev.net/viewtopic.php?f=17&t=3906
             (("add_subdirectory\\(.*/(glew|zlib)\"\\)") ""))
           #t))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f ; no check target
       #:configure-flags
       (list "-DUSE_WIIUSE=0"
             ;; Do not use the bundled zlib
             "-DNO_IRR_COMPILE_WITH_ZLIB_=TRUE"
             ;; FIXME: needs libopenglrecorder
             "-DBUILD_RECORDER=0"
             ;; Irrlicht returns an integer instead of a boolean
             "-DCMAKE_C_FLAGS=-fpermissive")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'unbundle
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "CMakeLists.txt"
               (("glew")
                (string-append (assoc-ref inputs "glew")
                               "/lib/libGLEW.a"))
               (("include_directories\\(\"\\$\\{PROJECT_SOURCE_DIR\\}/lib/glew/include\"\\)")
                (string-append "include_directories(\""
                               (assoc-ref inputs "glew")
                               "/include\")")))
             #t)))))
    (inputs
     `(("glew" ,glew)
       ("zlib" ,zlib)
       ("openal" ,openal)
       ("libvorbis" ,libvorbis)
       ("freetype" ,freetype)
       ("fribidi" ,fribidi)
       ("mesa" ,mesa)
       ("libx11" ,libx11)
       ("libxrandr" ,libxrandr)
       ("curl" ,curl)
       ;; The following input is needed to build the bundled and modified
       ;; version of irrlicht.
       ("libjpeg" ,libjpeg)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "https://supertuxkart.net/")
    (synopsis "3D kart racing game")
    (description "SuperTuxKart is a 3D kart racing game, with a focus on
having fun over realism.  You can play with up to 4 friends on one PC, racing
against each other or just trying to beat the computer; single-player mode is
also available.")
    (license license:gpl3+)))

(define-public gnujump
  (package
    (name "gnujump")
    (version "1.0.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/gnujump/gnujump-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "05syy9mzbyqcfnm0hrswlmhwlwx54f0l6zhcaq8c1c0f8dgzxhqk"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-before
          'configure 'link-libm
          (lambda _ (setenv "LIBS" "-lm"))))))
    (inputs
     `(("glu" ,glu)
       ("mesa" ,mesa)
       ("sdl" ,sdl)
       ("sdl-image" ,sdl-image)
       ("sdl-mixer" ,sdl-mixer)))
    (home-page "http://gnujump.es.gnu.org/")
    (synopsis
     "Game of jumping to the next floor, trying not to fall")
    (description
     "GNUjump is a simple, yet addictive game in which you must jump from
platform to platform to avoid falling, while the platforms drop at faster rates
the higher you go.  The game features multiplayer, unlimited FPS, smooth floor
falling, themeable graphics and sounds, and replays.")
    (license license:gpl3+)))

(define-public wesnoth
  (package
    (name "wesnoth")
    (version "1.12.6")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/wesnoth/wesnoth-"
                                  (version-major+minor version) "/wesnoth-"
                                  version "/"
                                  name "-" version ".tar.bz2"))
              (sha256
               (base32
                "0kifp6g1dsr16m6ngjq2hx19h851fqg326ps3krnhpyix963h3x5"))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f ; no check target
       #:configure-flags
       ;; XXX: Failed to compile with '-Werror=old-style-cast'.
       ;;   boost/mpl/assert.hpp:313:58: error:
       ;;     use of old-style cast [-Werror=old-style-cast]
       ;;   [...]
       ;;   cc1plus: all warnings being treated as errors
       '("-DENABLE_STRICT_COMPILATION=OFF")))
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("dbus" ,dbus)
       ("fribidi" ,fribidi)
       ("libvorbis" ,libvorbis)
       ("pango" ,pango)
       ("sdl-image" ,sdl-image)
       ("sdl-mixer" ,sdl-mixer)
       ("sdl-net" ,sdl-net)
       ("sdl-ttf" ,sdl-ttf)))
    (home-page "http://www.wesnoth.org/")
    (synopsis "Turn-based strategy game")
    (description
     "The Battle for Wesnoth is a fantasy, turn based tactical strategy game,
with several single player campaigns, and multiplayer games (both networked and
local).

Battle for control on a range of maps, using variety of units which have
advantages and disadvantages against different types of attacks.  Units gain
experience and advance levels, and are carried over from one scenario to the
next campaign.")
    (license license:gpl2+)))

(define-public wesnoth-server
  (package
    (inherit wesnoth)
    (name "wesnoth-server")
    (inputs
     `(("boost" ,boost)
       ("sdl-net" ,sdl-net)))
    (arguments
     (append
      (substitute-keyword-arguments (package-arguments wesnoth)
        ((#:configure-flags configure-flags)
         `(append ,configure-flags (list "-DENABLE_GAME=OFF"))))
      `(#:phases
        (modify-phases %standard-phases
          ;; Delete game assets not required by the server.
          (add-after 'install 'delete-data
            (lambda* (#:key outputs #:allow-other-keys)
              (delete-file-recursively (string-append (assoc-ref outputs "out")
                                                      "/share/wesnoth"))))))))
    (synopsis "Dedicated @emph{Battle for Wesnoth} server")
    (description "This package contains a dedicated server for @emph{The
Battle for Wesnoth}.")))

(define-public gamine
  (package
    (name "gamine")
    (version "1.5")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/gamine-game/"
                                  "gamine-" version ".tar.gz"))
              (sha256
               (base32
                "08wnk7w84c2413hwny89j2cn89cvfdf67bfc6wl0bf475if0mf4h"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)))
    (inputs
     `(("gstreamer" ,gstreamer)
       ("gst-plugins-base" ,gst-plugins-base) ;playbin plugin
       ("gst-plugins-good" ,gst-plugins-good) ;for wav playback
       ("gtk+" ,gtk+)))
    (arguments
     `(#:tests? #f
       #:make-flags
       (let ((out (assoc-ref %outputs "out")))
         (list (string-append "PREFIX=" out)
               (string-append "SYSCONFDIR=" out "/etc")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after
          'install 'wrap-gamine
          (lambda* (#:key outputs #:allow-other-keys)
            (let ((out             (assoc-ref outputs "out"))
                  (gst-plugin-path (getenv "GST_PLUGIN_SYSTEM_PATH")))
              (wrap-program (string-append out "/bin/gamine")
                `("GST_PLUGIN_SYSTEM_PATH" ":" prefix (,gst-plugin-path))))
            #t)))))
    (home-page "http://gamine-game.sourceforge.net/")
    (synopsis "Mouse and keyboard discovery for children")
    (description
     "Gamine is a game designed for young children who are learning to use the
mouse and keyboard.  The child uses the mouse to draw colored dots and lines
on the screen and keyboard to display letters.")
    ;; Most files under gpl2+ or gpl3+, but eat.wav under gpl3
    (license license:gpl3)))

(define-public raincat
  (package
    (name "raincat")
    (version "1.1.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://hackage.haskell.org/package/Raincat/Raincat-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "1aalh68h6799mv4vyg30zpskl5jkn6x2j1jza7p4lrflyifxzar8"))))
    (build-system haskell-build-system)
    (inputs
     `(("ghc-extensible-exceptions" ,ghc-extensible-exceptions)
       ("ghc-mtl" ,ghc-mtl)
       ("ghc-random" ,ghc-random)
       ("ghc-glut" ,ghc-glut)
       ("freeglut" ,freeglut)
       ("ghc-opengl" ,ghc-opengl)
       ("ghc-sdl" ,ghc-sdl)
       ("ghc-sdl-image" ,ghc-sdl-image)
       ("ghc-sdl-mixer" ,ghc-sdl-mixer)))
    (home-page "http://www.bysusanlin.com/raincat/")
    (synopsis "Puzzle game with a cat in lead role")
    (description "Project Raincat is a game developed by Carnegie Mellon
students through GCS during the Fall 2008 semester.  Raincat features game
play inspired from classics Lemmings and The Incredible Machine.  The project
proved to be an excellent learning experience for the programmers.  Everything
is programmed in Haskell.")
    (license license:bsd-3)))

(define-public manaplus
  (package
    (name "manaplus")
    (version "1.7.6.10")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://repo.manaplus.org/manaplus/download/"
                    version "/manaplus-" version ".tar.xz"))
              (sha256
               (base32
                "0l7swvpzq20am4w2rsjpp6fsvbjv07il6wbfy45a7h9zsdihmqhl"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       (list (string-append "CPPFLAGS=-I"
                            (assoc-ref %build-inputs "sdl-union")
                            "/include/SDL"))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("glu" ,glu)
       ("curl" ,curl)
       ("libxml2" ,libxml2)
       ("mesa" ,mesa)
       ("sdl-union" ,(sdl-union))))
    (home-page "http://manaplus.org")
    (synopsis "Client for 'The Mana World' and similar games")
    (description
     "ManaPlus is a 2D MMORPG client for game servers.  It is the only
fully supported client for @uref{http://www.themanaworld.org, The mana
world}, @uref{http://evolonline.org, Evol Online} and
@uref{http://landoffire.org, Land of fire}.")
    ;; "src/debug/*" and "src/sdl2gfx/*" are under Zlib.
    ;; "data/themes/{golden-delicious,jewelry}/*" are under CC-BY-SA.
    ;; The rest is under GPL2+.
    (license (list license:gpl2+ license:zlib license:cc-by-sa4.0))))

(define openttd-engine
  (package
    (name "openttd-engine")
    (version "1.7.1")
    (source
     (origin (method url-fetch)
             (uri (string-append "http://binaries.openttd.org/releases/"
                                 version "/openttd-" version "-source.tar.xz"))
             (sha256
              (base32
               "0dhv5bbbg1dmmq7fi3xss0a9jq2rqgb5sf9fsqzlsjcdm590j6b1"))
             (modules '((guix build utils)))
             (snippet
              ;; The DOS port contains proprietary software.
              '(delete-file-recursively "os/dos"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f              ; no "check" target
       #:phases
       (modify-phases %standard-phases
         ;; The build process fails if the configure script is passed the
         ;; option "--enable-fast-install".
         (replace 'configure
           (lambda* (#:key inputs outputs (configure-flags '())
                     #:allow-other-keys)
             (let ((out (assoc-ref outputs "out"))
                   (lzo (assoc-ref inputs "lzo")))
               (zero?
                (apply system* "./configure"
                       (string-append "--prefix=" out)
                       ;; Provide the "lzo" path.
                       (string-append "--with-liblzo2="
                                      lzo "/lib/liblzo2.a")
                       ;; Put the binary in 'bin' instead of 'games'.
                       "--binary-dir=bin"
                       configure-flags))))))))
    (native-inputs `(("pkg-config" ,pkg-config)))
    (inputs
     `(("allegro" ,allegro-4)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("icu4c" ,icu4c)
       ("libpng" ,libpng)
       ("lzo" ,lzo)
       ("sdl" ,sdl)
       ("xz" ,xz)
       ("zlib" ,zlib)))
    (synopsis "Transportation economics simulator")
    (description "OpenTTD is a game in which you transport goods and
passengers by land, water and air.  It is a re-implementation of Transport
Tycoon Deluxe with many enhancements including multiplayer mode,
internationalization support, conditional orders and the ability to clone,
autoreplace and autoupdate vehicles.  This package only includes the game
engine.  When you start it you will be prompted to download a graphics set.")
    (home-page "http://openttd.org/")
    ;; This package is GPLv2, except for a few files located in
    ;; "src/3rdparty/" which are under the 3-clause BSD, LGPLv2.1+ and Zlib
    ;; licenses.  In addition, this software contains an in-game downloader
    ;; from which the user may find non-functional data licensed under
    ;; different terms.
    (license (list license:bsd-3 license:gpl2 license:lgpl2.1+ license:zlib))))

(define openttd-opengfx
  (package
    (name "openttd-opengfx")
    (version "0.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://binaries.openttd.org/extra/opengfx/"
                           version "/opengfx-" version "-source.tar.xz"))
       (sha256
        (base32
         "0iz66q7p1mf00njfjbc4vibh3jaybki7armkl18iz7p6x4chp9zv"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list "CC=gcc"
                          (string-append "INSTALL_DIR="
                                         (assoc-ref %outputs "out")
                                         "/share/games/openttd/baseset/opengfx"))
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda _
             ;; Make sure HOME is writable for GIMP.
             (setenv "HOME" (getcwd))

             ;; Redirect stdout, not stderr, to /dev/null. This prevents
             ;; dos2unix from receiving its version information as a flag.
             (substitute* "Makefile"
               (("\\$\\(UNIX2DOS\\) -q --version 2>/dev/null")
                "$(UNIX2DOS) -q --version 1>/dev/null")))))
       ;; The check phase for this package only checks the md5sums of the built
       ;; GRF files against the md5sums of the release versions. Because we use
       ;; different software versions than upstream does, some of the md5sums
       ;; are different. However, the package is still reproducible, it's safe
       ;; to disable this test.
       #:tests? #f
       #:parallel-build? #f))
    (native-inputs `(("dos2unix" ,dos2unix)
                     ("gimp" ,gimp)
                     ("grfcodec" ,grfcodec)
                     ("nml" ,nml)
                     ("python" ,python-2)))
    (home-page "http://dev.openttdcoop.org/projects/opengfx")
    (synopsis "Base graphics set for OpenTTD")
    (description
     "The OpenGFX projects is an implementation of the OpenTTD base grahics
set that aims to ensure the best possible out-of-the-box experience.

OpenGFX provides you with...
@enumerate
@item All graphics you need to enjoy OpenTTD.
@item Uniquely drawn rail vehicles for every climate.
@item Completely snow-aware rivers.
@item Different river and sea water.
@item Snow-aware buoys.
@end enumerate")
    (license license:gpl2)))

(define openttd-opensfx
  (package
    (name "openttd-opensfx")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://binaries.openttd.org/extra/opensfx/"
             version "/opensfx-" version "-source.tar.gz"))
       (sha256
        (base32
         "03jxgp02ks31hmsdh4xh0xcpkb70ds8jakc9pfc1y9vdrdavh4p5"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("catcodec" ,catcodec)
       ("python" ,python2-minimal)))
    (arguments
     `(#:make-flags
       (list (string-append "INSTALL_DIR=" %output
                            "/share/games/openttd/baseset/opensfx"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'make-reproducible
           (lambda _
             ;; Remove the time dependency of the installed tarball by setting
             ;; the modification times if its members to 0.
             (substitute* "scripts/Makefile.def"
               (("-cf") " --mtime=@0 -cf"))
             #t))
         (delete 'configure))))
    (home-page "http://dev.openttdcoop.org/projects/opensfx")
    (synopsis "Base sounds for OpenTTD")
    (description "OpenSFX is a set of free base sounds for OpenTTD which make
it possible to play OpenTTD without requiring the proprietary sound files from
the original Transport Tycoon Deluxe.")
    (license license:cc-sampling-plus-1.0)))

(define openttd-openmsx
  (package
    (name "openttd-openmsx")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://binaries.openttd.org/extra/openmsx/"
             version "/openmsx-" version "-source.tar.gz"))
       (sha256
        (base32
         "0nskq97a6fsv1v6d62zf3yb8whzhqnlh3lap3va3nzvj7csjgf7c"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("python" ,python2-minimal)))
    (arguments
     `(#:make-flags
       (list (string-append "INSTALL_DIR=" %output
                            "/share/games/openttd/baseset"))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'install 'post-install
           ;; Rename openmsx-version to openmsx
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((install-directory (string-append (assoc-ref outputs "out")
                                                     "/share/games/openttd/baseset")))
               (rename-file (string-append install-directory "/openmsx-" ,version)
                            (string-append install-directory "/openmsx"))
               #t))))))
    (home-page "http://dev.openttdcoop.org/projects/openmsx")
    (synopsis "Music set for OpenTTD")
    (description "OpenMSX is a music set for OpenTTD which makes it possible
to play OpenTTD without requiring the proprietary music from the original
Transport Tycoon Deluxe.")
    (license license:gpl2)))

(define-public openttd
  (package
    (inherit openttd-engine)
    (name "openttd")
    (arguments
     `(#:configure-flags
       (list (string-append "--with-midi=" (assoc-ref %build-inputs "timidity++")
                            "/bin/timidity"))
       ,@(substitute-keyword-arguments (package-arguments openttd-engine)
           ((#:phases phases)
            `(modify-phases ,phases
               (add-after 'install 'install-data
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (for-each
                    (lambda (input)
                      (copy-recursively (assoc-ref inputs input)
                                        (assoc-ref outputs "out")))
                    (list "opengfx" "openmsx" "opensfx"))
                   #t)))))))
    (inputs
     `(("timidity++" ,timidity++)
       ,@(package-inputs openttd-engine)))
    (native-inputs
     `(("opengfx" ,openttd-opengfx)
       ("openmsx" ,openttd-openmsx)
       ("opensfx" ,openttd-opensfx)
       ,@(package-native-inputs openttd-engine)))))

(define-public openrct2
  (package
    (name "openrct2")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/OpenRCT2/OpenRCT2/archive/v"
                           version ".tar.gz"))
       (sha256
        (base32
         "1bahkzlf9k92cc4zs4nk4wy59323kiw8d3wm0vjps3kp7iznqyjx"))
       (file-name (string-append name "-" version ".tar.gz"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f ;; no tests available
       #:phases
        (modify-phases %standard-phases
          (add-after 'unpack 'fix-usr-share-paths
            (lambda* (#:key make-flags outputs #:allow-other-keys)
              ;; Fix some references to /usr/share.
              (substitute* "src/openrct2/platform/linux.c"
                (("/usr/share")
                (string-append (assoc-ref %outputs "out") "/share")))))
          (add-after 'build 'fix-cmake-install-file
            (lambda _
              ;; The build system tries to download a file and compare hashes.
              ;; Since we have no network, remove this so the install doesn't fail.
              (substitute* "cmake_install.cmake"
                (("EXPECTED_HASH SHA1=b587d83de508d0b104d14c599b76f8565900fce0")
                "")))))))
    (inputs `(("curl" ,curl)
              ("fontconfig" ,fontconfig)
              ("freetype" ,freetype)
              ("jansson" ,jansson)
              ("libpng" ,libpng)
              ("libzip" ,libzip)
              ("mesa" ,mesa)
              ("openssl" ,openssl)
              ("sdl2" ,sdl2)
              ("speexdsp" ,speexdsp)
              ("zlib" ,zlib)))
    (native-inputs
      `(("pkg-config" ,pkg-config)))
    (home-page "https://github.com/OpenRCT2/OpenRCT2")
    (synopsis "Free software re-implementation of RollerCoaster Tycoon 2")
    (description "OpenRCT2 is a free software re-implementation of
RollerCoaster Tycoon 2 (RCT2).  The gameplay revolves around building and
maintaining an amusement park containing attractions, shops and facilities.

Note that this package does @emph{not} provide the game assets (sounds,
images, etc.)")
    ;; See <https://github.com/OpenRCT2/OpenRCT2/wiki/Required-RCT2-files>
    ;; regarding assets.
    (license license:gpl3+)))

(define-public pinball
  (package
    (name "pinball")
    (version "0.3.1")
    (source
     (origin (method url-fetch)
             (uri (string-append "mirror://sourceforge/pinball/pinball/"
                                 "pinball-" version "/"
                                 "pinball-" version ".tar.gz"))
             (sha256
              (base32
               "1f2whlrfidwfh8lvr8cspcyirc6840r5d1ajm7x99qmngygrhixs"))
             (patches (search-patches "pinball-const-fix.patch"
                                      "pinball-cstddef.patch"
                                      "pinball-missing-separators.patch"
                                      "pinball-src-deps.patch"
                                      "pinball-system-ltdl.patch"))))
    (build-system gnu-build-system)
    (inputs
     `(("glu" ,glu)
       ("mesa" ,mesa)
       ("sdl" ,sdl)
       ("sdl-image" ,sdl-image)
       ("sdl-mixer" ,sdl-mixer)))
    (arguments
     '(#:configure-flags
       (list (string-append "CPPFLAGS=-I"
                            (assoc-ref %build-inputs "sdl-image")
                            "/include/SDL -I"
                            (assoc-ref %build-inputs "sdl-mixer")
                            "/include/SDL"))))
    (home-page "http://pinball.sourceforge.net")
    (synopsis "Pinball simulator")
    (description "The Emilia Pinball Project is a pinball simulator.  There
are only two levels to play with, but they are very addictive.")
    (license license:gpl2)))

(define-public pioneers
  (package
    (name "pioneers")
    (version "15.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://downloads.sourceforge.net/pio/"
                                  "pioneers-" version ".tar.gz"))
              (sha256
               (base32
                "1p1d18hrfmqcnghip3shkzcs5qkz6j99jvkdkqfi7pqdvjc323cs"))))
    (build-system gnu-build-system)
    (inputs `(("gtk+" ,gtk+)
              ("librsvg" ,librsvg)
              ("avahi" ,avahi)))
    (native-inputs `(("intltool" ,intltool)
                     ("pkg-config" ,pkg-config)))
    (synopsis "Board game inspired by The Settlers of Catan")
    (description "Pioneers is an emulation of the board game The Settlers of
Catan.  It can be played on a local network, on the internet, and with AI
players.")
    (home-page "http://pio.sourceforge.net/")
    (license license:gpl2+)))

(define-public einstein
  (package
    (name "einstein")
    (version "2.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://http.debian.net/debian/pool/main/e/"
                                  "einstein/einstein_2.0.dfsg.2.orig.tar.gz"))
              (sha256
               (base32
                "1hxrlv6n8py48j487i6wbb4n4vd55w0na69r7ccmmr9vmrsw5mlk"))
              (patches (search-patches "einstein-build.patch"))))
    (build-system gnu-build-system)
    (inputs
     `(("freetype" ,freetype)
       ("sdl" ,(sdl-union (list sdl sdl-mixer sdl-ttf)))
       ("zlib" ,zlib)))
    (native-inputs
     `(("font-dejavu" ,font-dejavu)))
    (arguments
     `(#:tests? #f ; no check target
       #:phases
        (modify-phases %standard-phases
          (replace 'configure
          (lambda* (#:key outputs inputs #:allow-other-keys)
            (let ((out (assoc-ref outputs "out"))
                  (dejavu (string-append (assoc-ref inputs "font-dejavu")
                                         "/share/fonts/truetype/DejaVuSans.ttf")))
              (substitute* "Makefile"
                (("PREFIX=/usr/local") (string-append "PREFIX=" out)))
              ;; The patch above registers a free font for use by the binary,
              ;; but the font is copied during the compile phase into a
              ;; resources file, so we need to make the ttf file available.
              (symlink dejavu "res/DejaVuSans.ttf")
              #t))))))
    (synopsis "Logic puzzle game")
    (description "The goal of this logic game is to open all cards in a 6x6
grid, using a number of hints as to their relative position.  The game idea
is attributed to Albert Einstein.")
    ;; The original home page has disappeared.
    (home-page (string-append "http://web.archive.org/web/20120521062745/"
                              "http://games.flowix.com/en/index.html"))
    ;; License according to
    ;; http://web.archive.org/web/20150222180355/http://www.babichev.info/en/projects/index.html
    ;; The source code is a DFSG-sanitized tarball and does not contain any
    ;; license information.
    (license license:gpl3+)))

(define-public powwow
  (package
    (name "powwow")
    (version "1.2.17")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://www.hoopajoo.net/static/projects/powwow-"
                    version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xmsg2y7qcvj67i9ilnih0mvfxcpni7fzrz343x9rdfnkkzf3pp8"))))
    (inputs
     `(("ncurses" ,ncurses)))
    (build-system gnu-build-system)
    (home-page "http://www.hoopajoo.net/projects/powwow.html")
    (synopsis "MUD and telnet client")
    (description
     "POWWOW is a client software which can be used for telnet as well as for
@dfn{Multi-User Dungeon} (MUD).  Additionally it can serve as a nice client for
the chat server psyced with the specific config located at
http://lavachat.symlynx.com/unix/")
    (license license:gpl2+)))

(define-public red-eclipse
  (let ((release "1.6.0")
        (revision 0)
        (data-sources
         '(("acerspyro" "07mzgdahnr3w3w7kf8nmy20r199rimfx9ryqxjdr793sw0vawqd3")
           ("actors" "1hkgscfhg0kmwgym0mw56fhcckzbb2hh3nsvd45v4mdfyk0xnrm7")
           ("appleflap" "1q4xs3x904mrrbxzv6lpr3lywm8p6i8339ijzy9j091s2wdl51ka")
           ("blendbrush" "004md2haysr9w8fj6l7bj9wcfjqrq9wx1rrjf9dv16k5sbrkqza9")
           ("caustics" "1qmmv8ds70j1ixy4rvli309vbcyjq1l5j1wri6nbnjay10f9fcgq")
           ("crosshairs" "0q1vadg5cai9i6igl6y08774fd05gav0kinbgb2757n47ig50bns")
           ("dziq" "1s9248ky2qqy24z9c2vgpisz500dvsaj249pv1fkrxgsypjm1z6v")
           ("elyvisions" "15synpms05996v4c4kdl0h899spl4z7si9kl8c4m7rvc2yvin1ga")
           ("fonts" "1l4727ai8mphi7n3wcjp2lh3p47nh6w82s5dpqbbjpqr9gilb69j")
           ("freezurbern" "0hcdbzs02mvpsfhmahhqjv6pd8lbsag1bm6rpy61ns5qwmhg96ys")
           ("john" "1whyvlx87mb83kfb7jhhnwz9s7lry4li8l3xar61vmlqgmsnz33d")
           ("jojo" "02wxa93f5al4rlnsdjpd0hlnca0ympnj8481lgdxx70hny8zi3qi")
           ("jwin" "1gb4l7lbhr150hml1y0wbyx7266q5nslh6n494wwrrsvp11s2qk8")
           ("luckystrike" "0wy2spvhx5k233fsl283250ym5bqvkk8i6i19sw3zvzyxp2p4yq9")
           ("maps" "1dmvp9mskval606z5srjd909jpm6qz4fdcpaszkkhfr5ajbj30vq")
           ("mayhem" "0hkzzx0rxda70ixw9lfh9v1dpsbn2dj86jrr3zxjgasbgaxw37ax")
           ("mikeplus64" "144fxhp4qjqjw3gvhf7ym6rnfxvxc0zvd3f54jg1jgnccc1hfyah")
           ("misc" "0bpvibyc6vjhbzsf67xxn85yq2h97xs96icbskwzs2wsd860kq8c")
           ("nieb" "0d72wsibk9sg9nhin3fwzz9zljiccyln0fn42y2q2xbd4my23b1k")
           ("nobiax" "19lr36ys98cmpp739svjar1j942fbxz6r062gi7ygh89zh9yrgfy")
           ("particles" "02pnq8ksl7f6kqxss3aza98jssdq2s41rhkhki71ynavp2a5akar")
           ("philipk" "1xkrb7wa1pyhbs4xxx7vnnzsxrqzswk7gjbdac7i7rj0lwnfaij2")
           ("projectiles" "1hra0f1ifiddh16fv4pqcr2amf046lf445v0653zkyri43zgrj5f")
           ("props" "0ff6a8pz62f4nsk4c9cr50kirw108a661y5j6fvlsjickw3xjmyv")
           ("skyboxes" "1lq58dhrdiivq7llkiyqwpi3bwa89r8hbi98p7zjhw7wdn34i6n2")
           ("snipergoth" "0d5qf01bxd4dlffgxf8i91zq6mbyjmfd00dpyligpfj6fdbz87gc")
           ("sounds" "0z6jmxsr3w735hrdnxypdb0gi399pwkaycv9grjpiqy43j3ic7gj")
           ("textures" "0k5a47g2z99xn17vw7bqbp0w726gxmk33g5gwmqvfhxxxzzwimvi")
           ("torley" "12x23l8xcv9ard5v76lb210lvp66whsns2p3k3xkd1sabp5ixbd5")
           ("trak" "03kmwj47yb3dqzb6k9kilna9ja8c6jcnblvbs72x15767fl496pb")
           ("ulukai" "0vvd016a7x981ixif6dnlg45s0ak7i89pgyrgwy2fpd94nl2am15")
           ("unnamed" "18sxvdha41njp6g8wn56mjy6w9x778c793gh8fr0h9cnysb5gfmi")
           ("vanities" "1p38mc2566bmb4vdyr9n9s6fkwmynp2xlpdq2a97gzgi4nmm0232")
           ("vegetation" "0pf3qvqzabdcri5za61z6m89b5hq7sd3q0idkazmx88a62mcclkb")
           ("weapons" "1jr05y9qhhx53plvir35srvv3cmn6wa065p3bskx6h1x6dcbx3c6")
           ("wicked" "14b9f92h8hccp7a015z6rqgbs8236sdyxnwsq991ylnap7cbwvam"))))
    (package
      (name "red-eclipse")
      (version (if (zero? revision)
                   release
                   (string-append release "-"
                                  (number->string revision))))
      (source (origin
                (method url-fetch)
                (uri (string-append "https://github.com/red-eclipse/base"
                                    "/archive/v" release ".tar.gz"))
                (file-name (string-append name "-" version ".tar.gz"))
                (sha256
                 (base32
                  "1vs9k6f5fgsiy1n72imlqm8khjwm8cryc08zwd4gr7yxlxv45bs0"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f            ; no check target
         #:make-flags (list "CC=gcc" "-Csrc"
                            (string-append "INSTDIR="
                                           (assoc-ref %outputs "out") "/bin")
                            (string-append "prefix="
                                           (assoc-ref %outputs "out")))
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'unpack-data
             (lambda* (#:key inputs #:allow-other-keys)
               (delete-file-recursively "data")
               (mkdir "data")
               (for-each (lambda (name)
                           (invoke "tar" "-xvf"
                                   (assoc-ref inputs name)
                                   "-Cdata"
                                   "--transform"
                                   (string-append "s/"
                                                  name "-" ,release "/"
                                                  name "/")))
                         (list ,@(map car data-sources)))
               #t))
           (add-after 'unpack-data 'add-store-data-package-path-as-default
             (lambda* (#:key outputs #:allow-other-keys)
               (substitute* "src/engine/server.cpp"
                 (("(else[[:space:]]*)((addpackagedir\\()\"data\"(\\);))"
                   _
                   else_part
                   addpackagedir_original
                   addpackagedir_open
                   addpackagedir_close)
                  (string-append else_part
                                 "{ "
                                 addpackagedir_open
                                 "\""
                                 (assoc-ref outputs "out")
                                 "/share/redeclipse/data\""
                                 addpackagedir_close
                                 " "
                                 addpackagedir_original
                                 " }")))
               #t))
           (delete 'configure)  ; no configure script
           (add-after 'set-paths 'set-sdl-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (setenv "CPATH"
                       (string-append (assoc-ref inputs "sdl-union")
                                      "/include/SDL2"))
               #t))
           (add-after 'install 'copy-data
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 (copy-recursively "config"
                                   (string-append out "/config"))
                 (copy-file "doc/examples/servinit.cfg"
                            (string-append out "/config/servinit.cfg"))
                 (copy-recursively "data"
                                   (string-append out "/share/redeclipse/data"))
                 (mkdir-p (string-append out "/lib/redeclipse"))
                 (symlink (string-append out "/share/redeclipse/data")
                          (string-append out "/lib/redeclipse/data")))
               #t))
           (add-after 'copy-data 'wrap-program
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (bin (string-append out "/bin")))
                 (with-directory-excursion bin
                   (rename-file "redeclipse_linux"
                                ".redeclipse_linux-real")
                   (rename-file "redeclipse_server_linux"
                                ".redeclipse_server_linux-real")
                   (call-with-output-file "redeclipse_linux"
                     (lambda (port)
                       (format port "#!~a/bin/sh
# Run the thing from its home, otherwise it just bails out.
cd \"~a\"
exec -a \"$0\" ~a/.redeclipse_linux-real~%"
                               (assoc-ref inputs "bash") ;implicit input
                               (string-append out)
                               (string-append bin))))
                   (call-with-output-file "redeclipse_server_linux"
                     (lambda (port)
                       (format port "#!~a/bin/sh
# Run the thing from its home, otherwise it just bails out.
cd \"~a\"
exec -a \"$0\" ~a/.redeclipse_server_linux-real~%"
                               (assoc-ref inputs "bash") ;implicit input
                               (string-append out)
                               (string-append bin))))
                   (chmod "redeclipse_linux" #o555)
                   (chmod "redeclipse_server_linux" #o555)))
               #t)))))
      (native-inputs `(("pkg-config" ,pkg-config)))
      (inputs
       `(("curl" ,curl)
         ("glu" ,glu)
         ("sdl-union" ,(sdl-union (list sdl2
                                        sdl2-image
                                        sdl2-mixer)))
         ;; Create origin records for the many separate data packages.
         ,@(map (match-lambda
                  ((name hash)
                   (list name
                         (origin
                           (method url-fetch)
                           (uri (string-append
                                 "https://github.com/red-eclipse/"
                                 name "/archive/v" release ".tar.gz"))
                           (sha256 (base32 hash))
                           (file-name (string-append name "-" version
                                                     ".tar.gz"))))))
                data-sources)))
      (home-page "http://redeclipse.net/")
      (synopsis "Arena shooter derived from the Cube 2 engine")
      (description
       "Red Eclipse is an arena shooter, created from the Cube2 engine.
Offering an innovative parkour system and distinct but all potent weapons,
Red Eclipse provides fast paced and accessible gameplay.")
      ;; The engine is under Zlib; data files are covered by the other
      ;; licenses.  More details at <http://redeclipse.net/wiki/License>.
      (license (list license:expat
                     license:zlib
                     license:cc-by-sa3.0
                     license:cc-by3.0
                     license:cc0)))))

(define-public grue-hunter
  (package
    (name "grue-hunter")
    (version "1.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://jxself.org/" name ".tar.gz"))
              (sha256
               (base32
                "1hjcpy5439qs3v2zykis7hsi0i17zjs62gks3zd8mnfw9ni4i2h3"))))
    (build-system trivial-build-system) ; no Makefile.PL
    (arguments `(#:modules ((guix build utils))
                 #:builder
                 (begin
                   (use-modules (guix build utils))
                   (use-modules (srfi srfi-1))

                   (let* ((tarball (assoc-ref %build-inputs "tarball"))
                          (perl    (string-append (assoc-ref %build-inputs
                                                             "perl")
                                                  "/bin"))
                          (gzip    (string-append (assoc-ref %build-inputs
                                                             "gzip")
                                                  "/bin/gzip"))
                          (tar     (string-append (assoc-ref %build-inputs
                                                             "tar")
                                                  "/bin/tar"))
                          (out     (assoc-ref %outputs "out"))
                          (bin     (string-append out "/bin"))
                          (doc     (string-append out
                                                  "/share/doc/grue-hunter")))
                     (begin
                       (copy-file tarball "grue-hunter.tar.gz")
                       (zero? (system* gzip "-d" "grue-hunter.tar.gz"))
                       (zero? (system* tar "xvf"  "grue-hunter.tar"))

                       (mkdir-p bin)
                       (copy-file "grue-hunter/gh.pl"
                                  (string-append bin "/grue-hunter"))
                       (patch-shebang (string-append bin "/grue-hunter")
                                      (list perl))

                       (install-file "grue-hunter/AGPLv3.txt" doc))))))
    (inputs `(("perl" ,perl)
              ("tar" ,tar)
              ("gzip" ,gzip)
              ("tarball" ,source)))
    (home-page "http://jxself.org/grue-hunter.shtml")
    (synopsis "Text adventure game")
    (description
     "Grue Hunter is a text adventure game written in Perl.  You must make
your way through an underground cave system in search of the Grue.  Can you
capture it and get out alive?")
    (license license:agpl3+)))

(define-public lierolibre
  (package
    (name "lierolibre")
    (version "0.5")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://launchpad.net/lierolibre/trunk/"
                                  version "/+download/lierolibre-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1cf1gvsn4qq190lrf9k5bpjnqwlcfw7pajvdnh7z5r4jqw0rsbl9"))
              (patches
               (search-patches "lierolibre-check-unaligned-access.patch"
                               "lierolibre-try-building-other-arch.patch"
                               "lierolibre-remove-arch-warning.patch"
                               "lierolibre-newer-libconfig.patch"
                               "lierolibre-is-free-software.patch"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Delete pre-compiled files.
                  (delete-file "data/LIERO.CHR")
                  (delete-file "data/LIERO.SND")
                  #t))))
    (build-system gnu-build-system)
    (native-inputs
     `(("imagemagick" ,imagemagick)
       ("pkg-config" ,pkg-config)
       ("util-linux" ,util-linux)
       ("sox" ,sox)))
    (inputs
     `(("boost" ,boost)
       ("libconfig" ,libconfig)
       ("sdl-union" ,(sdl-union (list sdl sdl-image sdl-mixer)))
       ("zlib" ,zlib)))
    (home-page "https://gitlab.com/lierolibre/lierolibre")
    (synopsis "Old-school earthworm action game")
    (description
     "lierolibre is an earthworm action game where you fight another player
(or the computer) underground using a wide array of weapons.

Features:
@itemize
@item 2 worms, 40 weapons, great playability, two game modes: Kill'em All
and Game of Tag, plus AI-players without true intelligence!
@item Dat nostalgia.
@item Extensions via a hidden F1 menu:
@itemize
@item Replays
@item Game controller support
@item Powerlevel palettes
@end itemize
@item Ability to write game variables to plain text files.
@item Ability to load game variables from both EXE and plain text files.
@item Scripts to extract and repack graphics, sounds and levels.
@end itemize

To switch between different window sizes, use F6, F7 and F8, to switch to
fullscreen, use F5 or Alt+Enter.")
    ;; Code mainly BSD-2, some parts under Boost 1.0. All assets are WTFPL2.
    (license (list license:bsd-2 license:boost1.0 license:wtfpl2))))

(define-public warzone2100
  (package
    (name "warzone2100")
    (version "3.2.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/" name
                                  "/releases/" version "/" name "-" version
                                  ".tar.xz"))
              (sha256
               (base32
                "1nd609s0g4sya3r4amhkz3f4dpdmm94vsd2ii76ap665a1nbfrhg"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'link-tests-with-qt
           (lambda _
             (substitute* "tests/Makefile.in"
               (("(framework_linktest_LDADD|maptest_LDADD) = " prefix)
                (string-append prefix "$(QT5_LIBS) ")))
             #t))
         (add-after 'unpack 'remove-reference-to-missing-file
           (lambda _
             (substitute* "icons/Makefile.in"
               (("\\$\\(INSTALL_DATA\\) \\$\\(srcdir\\)/warzone2100.appdata.xml.*") ""))
             #t))
         (add-after 'unpack 'patch-for-qt5.8
           (lambda _
             (substitute* "lib/widget/editbox.cpp"
               (("== '\\\\0'")
                "== QChar('\\0')"))
             #t)))))
    (native-inputs `(("pkg-config" ,pkg-config)
                     ("unzip" ,unzip)
                     ("zip" ,zip)))
    (inputs `(("fontconfig" ,fontconfig)
              ("freetype" ,freetype)
              ("fribidi" ,fribidi)
              ("glew" ,glew)
              ("libtheora" ,libtheora)
              ("libvorbis" ,libvorbis)
              ("libxrandr" ,libxrandr)
              ("openal" ,openal)
              ("physfs" ,physfs)
              ("qtbase" ,qtbase)
              ("qtscript" ,qtscript)
              ("openssl" ,openssl)
              ("quesoglc" ,quesoglc)
              ("sdl2" ,sdl2)))
    (home-page "http://wz2100.net")
    (synopsis "3D Real-time strategy and real-time tactics game")
    (description
     "Warzone 2100 offers campaign, multi-player, and single-player skirmish
modes. An extensive tech tree with over 400 different technologies, combined
with the unit design system, allows for a wide variety of possible units and
tactics.")
    ; Everything is GPLv2+ unless otherwise specified in COPYING.NONGPL
    (license (list license:bsd-3
                   license:cc0
                   license:cc-by-sa3.0
                   license:expat
                   license:gpl2+
                   license:lgpl2.1+))))

(define-public starfighter
  (package
    (name "starfighter")
    (version "1.7")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://savannah/starfighter/"
                    (version-major+minor version) "/"
                    name "-" version "-src.tar.gz"))
              (sha256
               (base32
                "1646hpjq8bz2fkfkja1dah511hn7zd2r7da4w9c9blhad3p5732v"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("sdl2" ,sdl2)
       ("sdl2-image" ,sdl2-image)
       ("sdl2-mixer" ,sdl2-mixer)))
    (home-page "http://starfighter.nongnu.org/")
    (synopsis "2D scrolling shooter game")
    (description
     "In the year 2579, the intergalactic weapons corporation, WEAPCO, has
dominated the galaxy.  Guide Chris Bainfield and his friend Sid Wilson on
their quest to liberate the galaxy from the clutches of WEAPCO.  Along the
way, you will encounter new foes, make new allies, and assist local rebels
in strikes against the evil corporation.")
    ;; gfx and music are under CC-BY 3.0, CC-BY-SA 3.0, CC0 or Public Domain.
    (license (list license:gpl3+
                   license:cc-by3.0
                   license:cc-by-sa3.0
                   license:cc0
                   license:public-domain))))

(define-public chromium-bsu
  (package
    (name "chromium-bsu")
    (version "0.9.16.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/" name
                                  "/Chromium B.S.U. source code/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "0jk2w5b6s6nkzri585bbz16cif2fhqcnl5l1mq3rd98r9nil3hd1"))))
    (build-system gnu-build-system)
    (native-inputs `(("pkg-config" ,pkg-config)))
    (inputs `(("gettext" ,gettext-minimal)
              ("glu" ,glu)
              ("quesoglc" ,quesoglc)
              ("sdl-union" ,(sdl-union (list sdl sdl-image sdl-mixer)))))
    (home-page "http://chromium-bsu.sourceforge.net/")
    (synopsis "Fast-paced, arcade-style, top-scrolling space shooter")
    (description
     "In this game you are the captain of the cargo ship Chromium B.S.U. and
are responsible for delivering supplies to the troops on the front line.  Your
ship has a small fleet of robotic fighters which you control from the relative
safety of the Chromium vessel.")
    ;; Clarified Artistic License for everything but sound, which is covered
    ;; by the Expat License.
    (license (list license:clarified-artistic license:expat))))

(define-public tuxpaint
  (package
    (name "tuxpaint")
    (version "0.9.22")                  ;keep VER_DATE below in sync
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/tuxpaint/tuxpaint/"
                           version "/tuxpaint-" version ".tar.gz"))
       (sha256
        (base32
         "1qrbrdck9yxpcg3si6jb9i11w8lw9h4hqad0pfaxgyiniqpr7gca"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; Remove win32 directory which contains binary dll's and the
           ;; deprecated visualc directory.
           (for-each delete-file-recursively '("win32" "visualc"))
           (substitute* "Makefile"
             ;; Do not rely on $(GPERF) being an absolute file name
             (("\\[ -x \\$\\(GPERF\\) \\]")
              "$(GPERF) --version >/dev/null 2>&1"))))
       (patches (search-patches "tuxpaint-stamps-path.patch"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("gperf" ,gperf)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("cairo" ,cairo)
       ("fribidi" ,fribidi)
       ("gettext" ,gettext-minimal)
       ("libpng" ,libpng)
       ("librsvg" ,librsvg)
       ("libpaper" ,libpaper)
       ("netpbm" ,netpbm)
       ("sdl" ,(sdl-union (list sdl sdl-mixer sdl-ttf sdl-image)))))
    ;; TODO: Use system fonts rather than those in data/fonts
    (arguments
     `(#:make-flags `("VER_DATE=2014-08-23"
                      "GPERF=gperf" "CC=gcc"
                      "SDL_PCNAME=sdl SDL_image SDL_mixer SDL_ttf"
                      ,(string-append "PREFIX=" %output)
                      "GNOME_PREFIX=$(PREFIX)"
                      "COMPLETIONDIR=$(PREFIX)/etc/bash_completion.d")
       #:parallel-build? #f             ;fails on some systems
       #:tests? #f                      ;No tests
       #:phases (modify-phases %standard-phases
                  (delete 'configure)   ;no configure phase
                  (add-after 'install 'fix-import
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (net (assoc-ref inputs "netpbm"))
                             (tpi (string-append out "/bin/tuxpaint-import")))
                        (substitute* tpi
                          ;; Point to installation prefix so that the default
                          ;; configure file is found.
                          (("/usr/local") out))
                        ;; tuxpaint-import uses a bunch of programs from
                        ;; netpbm, so make sure it knows where those are
                        (wrap-program tpi
                          `("PATH" ":" prefix
                            (,(string-append net "/bin"))))))))))
    (native-search-paths
     (list (search-path-specification
            (variable "TUXPAINT_STAMPS_PATH")
            (files '("share/tuxpaint/stamps")))))
    (home-page "http://www.tuxpaint.org")
    (synopsis "Drawing software for children")
    (description
     "Tux Paint is a free drawing program designed for young children (kids
ages 3 and up).  It has a simple, easy-to-use interface; fun sound effects;
and an encouraging cartoon mascot who helps guide children as they use the
program.  It provides a blank canvas and a variety of drawing tools to help
your child be creative.")
    (license license:gpl2+)))

(define-public tuxpaint-stamps
  (package
    (name "tuxpaint-stamps")
    (version "2014.08.23")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/tuxpaint/tuxpaint-stamps/"
                           (string-map (λ (x) (if (eq? x #\.) #\- x)) version)
                           "/tuxpaint-stamps-" version ".tar.gz"))
       (sha256
        (base32
         "0rhlwrjz44wp269v3rid4p8pi0i615pzifm1ym6va64gn1bms06q"))))
    (build-system trivial-build-system)
    (native-inputs
     `(("tar" ,tar)
       ("gzip" ,gzip)))
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (setenv "PATH"
                           (string-append
                            (assoc-ref %build-inputs "tar") "/bin" ":"
                            (assoc-ref %build-inputs "gzip") "/bin"))
                   (system* "tar" "xvf" (assoc-ref %build-inputs "source"))
                   (chdir (string-append ,name "-" ,version))
                   (let ((dir (string-append %output "/share/tuxpaint/stamps")))
                     (mkdir-p dir)
                     (copy-recursively "stamps" dir)))))
    (home-page (package-home-page tuxpaint))
    (synopsis "Stamp images for Tux Paint")
    (description
     "This package contains a set of \"Rubber Stamp\" images which can be used
with the \"Stamp\" tool within Tux Paint.")
    (license license:gpl2+)))

(define-public tuxpaint-config
  (package
    (name "tuxpaint-config")
    (version "0.0.13")                  ;keep VER_DATE below in sync
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/tuxpaint/tuxpaint-config/"
                           version "/tuxpaint-config-" version ".tar.gz"))
       (sha256
        (base32
         "1z12s46mvy87qs3vgq9m0ki9pp21zqc52mmgphahpihw3s7haf6v"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)))
    (inputs
     `(("fltk" ,fltk)
       ("libpaper" ,libpaper)
       ;; TODO: Should the following be propagated by fltk?
       ("libx11" ,libx11)
       ("libxft" ,libxft)
       ("mesa" ,mesa)))
    (arguments
     `(#:make-flags `("VER_DATE=2014-08-23"
                      "CONFDIR=/etc/tuxpaint" ;don't write to store
                      ,(string-append "PREFIX=" %output)
                      "GNOME_PREFIX=$(PREFIX)")
       #:parallel-build? #f             ;race conditions
       #:tests? #f                      ;no tests
       #:phases (modify-phases %standard-phases
                  (delete 'configure)   ;no configure phase
                  (add-before 'install 'gzip-no-name
                    (lambda* _
                      (substitute* "Makefile"
                        ;; tuxpaint-config compresses its own documentation;
                        ;; make sure it uses flags for reproducibility.
                        (("gzip") "gzip --no-name"))))
                  (add-before 'install 'make-install-dirs
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((out (assoc-ref outputs "out")))
                        (mkdir-p (string-append out "/bin"))
                        #t))))))
    (home-page (package-home-page tuxpaint))
    (synopsis "Configure Tux Paint")
    (description
     "Tux Paint Config is a graphical configuration editor for Tux Paint.")
    (license license:gpl2)))            ;no "or later" present

(define-public supertux
  (package
   (name "supertux")
   (version "0.5.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/SuperTux/supertux/"
                                "releases/download/v" version "/SuperTux-v"
                                version "-Source.tar.gz"))
            (sha256
             (base32
              "1i8avad7w7ikj870z519j383ldy29r6f956bs38cbr8wk513pp69"))))
   (arguments
    '(#:tests? #f
      #:configure-flags '("-DINSTALL_SUBDIR_BIN=bin"
                          "-DENABLE_BOOST_STATIC_LIBS=OFF")))
   (build-system cmake-build-system)
   (inputs `(("sdl2" ,sdl2)
             ("sdl2-image" ,sdl2-image)
             ("sdl2-mixer" ,sdl2-mixer)
             ("openal" ,openal)
             ("mesa" ,mesa)
             ("glew" ,glew)
             ("libvorbis" ,libvorbis)
             ("libogg" ,libogg)
             ("physfs" ,physfs)
             ("curl" ,curl)
             ("boost" ,boost)))
   (native-inputs `(("pkg-config" ,pkg-config)))
   (synopsis "2D platformer game")
   (description "SuperTux is a free classic 2D jump'n run sidescroller game
in a style similar to the original Super Mario games covered under
the GNU GPL.")
   (home-page "https://supertuxproject.org/")
   (license license:gpl3+)))

(define-public tintin++
  (package
    (name "tintin++")
    (version "2.01.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/tintin"
                                  "/TinTin++ Source Code/" version
                                  "/tintin" "-" version ".tar.gz"))
              (sha256
               (base32
                "1g7bh8xs1ml0iyraps3a3dzaycci922y7fk5j0wyr4ssyjzsy8nx"))))
    (inputs
     `(("gnutls" ,gnutls)
       ("pcre" ,pcre)
       ("readline" ,readline)
       ("zlib" ,zlib)))
    (arguments
     '(#:tests? #f ; no test suite
       #:phases
       (modify-phases %standard-phases
         ;; The source is in tt/src.
         (add-before 'configure 'chdir
           (lambda _
             (chdir "src")
             #t)))))
    (build-system gnu-build-system)
    (home-page "http://tintin.sourceforge.net/")
    (synopsis "MUD client")
    (description
     "TinTin++ is a MUD client which supports MCCP (Mud Client Compression Protocol),
MMCP (Mud Master Chat Protocol), xterm 256 colors, most TELNET options used by MUDs,
as well as those required to login via telnet on Linux / Mac OS X servers, and an
auto mapper with a VT100 map display.")
    (license license:gpl2+)))

(define-public laby
  (package
    (name "laby")
    (version "0.6.4")
    (source
     (origin (method url-fetch)
             (uri (string-append
                   "https://github.com/sgimenez/laby/archive/"
                   name "-" version ".tar.gz"))
             (sha256
              (base32
               "0gyrfa95l1qka7gbjf7l6mk7mbfvph00l0c995ia272qdw7rjhyf"))
             (patches (search-patches "laby-make-install.patch"))))
    (build-system gnu-build-system)
    (inputs
     `(("lablgtk" ,lablgtk)
       ("ocaml" ,ocaml)
       ("ocaml-findlib" ,ocaml-findlib)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-before 'build 'setenv
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((lablgtk (assoc-ref inputs "lablgtk")))
               (setenv "LD_LIBRARY_PATH"
                       (string-append lablgtk "/lib/ocaml/stublibs"))))))
       #:tests? #f ; no 'check' target
       #:make-flags
       (list (string-append "PREFIX=" (assoc-ref %outputs "out")) "all")))
    (home-page "https://sgimenez.github.io/laby/")
    (synopsis "Programming game")
    (description "Learn programming, playing with ants and spider webs ;-)
Your robot ant can be programmed in many languages: OCaml, Python, C, C++,
Java, Ruby, Lua, JavaScript, Pascal, Perl, Scheme, Vala, Prolog.  Experienced
programmers may also add their own favorite language.")
    (license license:gpl3+)))

(define-public bambam
  (package
    (name "bambam")
    (version "0.5")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/porridge/bambam/archive/"
                            version ".tar.gz"))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "10w110mjdwbvddzihh9rganvvjr5jfiz8cs9n7w12zndwwcc3ria"))))
    (build-system python-build-system)
    (arguments
     `(#:python ,python-2
       #:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (delete 'build)
         (add-before 'install 'patch-data-dir-location
           (lambda _
             (substitute* "bambam.py"
               (("'data'") "'../share/bambam/data'"))
             #t))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out   (assoc-ref outputs "out"))
                    (bin   (string-append out "/bin"))
                    (share (string-append out "/share")))
               (mkdir-p bin)
               (copy-file "bambam.py" (string-append bin "/bambam"))
               (install-file "bambam.6" (string-append share "/man/man6"))
               (copy-recursively "data" (string-append share "/bambam/data")))
             #t)))))
    (inputs
     `(("python-pygame" ,python-pygame)))
    (home-page "https://github.com/porridge/bambam")
    (synopsis "Keyboard mashing and doodling game for babies")
    (description "Bambam is a simple baby keyboard (and gamepad) masher
application that locks the keyboard and mouse and instead displays bright
colors, pictures, and sounds.")
    (license license:gpl3+)))

(define-public mrrescue
  (package
    (name "mrrescue")
    (version "1.02e")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/SimonLarsen/mrrescue/releases/"
                    "download/" version "/" name version ".love"))
              (file-name (string-append name "-" version ".love"))
              (sha256
               (base32
                "0jwzbwkgp1l5ia6c7s760gmdirbsncp6nfqp7vqdqsfb63la9gl2"))))
    (build-system trivial-build-system)
    (arguments
     '(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((out     (assoc-ref %outputs "out"))
                (bindir  (string-append out "/bin"))
                (prog    (string-append bindir "/mrrescue"))
                (source  (assoc-ref %build-inputs "source"))
                (bash    (string-append (assoc-ref %build-inputs "bash")
                                        "/bin/bash"))
                (love    (string-append (assoc-ref %build-inputs "love")
                                        "/bin/love")))
           (mkdir-p bindir)
           (with-output-to-file prog
             (lambda ()
               (format #t "#!~a~%" bash)
               (format #t "exec -a mrrescue \"~a\" \"~a\"~%" love source)))
           (chmod prog #o755)
           #t))))
    (inputs
     `(("bash" ,bash)
       ("love" ,love)))
    (home-page "http://tangramgames.dk/games/mrrescue")
    (synopsis "Arcade-style fire fighting game")
    (description
     "Mr. Rescue is an arcade styled 2d action game centered around evacuating
civilians from burning buildings.  The game features fast paced fire
extinguishing action, intense boss battles, a catchy soundtrack and lots of
throwing people around in pseudo-randomly generated buildings.")
    (license (list license:zlib             ; for source code
                   license:cc-by-sa3.0))))  ; for graphics and music assets

(define-public hyperrogue
  (package
    (name "hyperrogue")
    (version "10.0g")
    ;; When updating this package, be sure to update the "hyperrogue-data"
    ;; origin in native-inputs.
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://www.roguetemple.com/z/hyper/"
                    name (string-join (string-split version #\.) "")
                    "-src.tgz"))
              (sha256
               (base32
                "0f68pcnsgl406dhm91ckn3f364bar9m9i5njp9vrmvhvv9p2icy0"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no check target
       #:make-flags '("CXXFLAGS=-std=c++11")
       #:phases
       (modify-phases %standard-phases
         (add-after 'set-paths 'set-sdl-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "CPATH"
                     (string-append (assoc-ref inputs "sdl-union")
                                    "/include/SDL"))))
         ;; Fix font and music paths.
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (share-dir (string-append out "/share/hyperrogue"))
                    (dejavu-dir (string-append
                                 (assoc-ref inputs "font-dejavu")
                                 "/share/fonts/truetype"))
                    (dejavu-font "DejaVuSans-Bold.ttf")
                    (music-file "hyperrogue-music.txt"))
               (substitute* "basegraph.cpp"
                 ((dejavu-font)
                  (string-append dejavu-dir "/" dejavu-font)))
               (substitute* "sound.cpp"
                 (((string-append "\\./" music-file))
                  (string-append share-dir "/" music-file))
                 (("sounds/")
                  (string-append share-dir "/sounds/")))
               (substitute* music-file
                 (("\\*/")
                  (string-append share-dir "/sounds/"))))
             #t))
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (share-dir (string-append out "/share/hyperrogue")))
               (mkdir-p bin)
               (copy-file "hyper" (string-append bin "/hyperrogue"))
               (install-file "hyperrogue-music.txt" share-dir))
             #t))
         (add-after 'install 'install-data
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((data (assoc-ref inputs "hyperrogue-data"))
                    (out (assoc-ref outputs "out"))
                    (sounds (string-append out "/share/hyperrogue/sounds"))
                    (unzip (string-append (assoc-ref inputs "unzip") "/bin/unzip")))
               (and
                ;; Extract media license information into sounds directory.
                (zero?
                 (system* unzip "-j" data
                          (string-append
                           "hyperrogue"
                           (string-join (string-split ,version #\.) "")
                           "/sounds/credits.txt") "-d" sounds))
                ;; Extract sounds and music into sounds directory.
                (zero?
                 (system* "unzip" "-j" data
                          (string-append
                           "hyperrogue"
                           (string-join (string-split ,version #\.) "")
                           "/*.ogg") "-d" sounds)))))))))
    (native-inputs
     `(("hyperrogue-data"
        ,(origin
           (method url-fetch)
           (uri
            (string-append
             "http://www.roguetemple.com/z/hyper/" name
             (string-join (string-split version #\.) "")
             "-win.zip"))
           (sha256
            (base32
             "0bnp077qvlmxjlz1jjd6kpghlv9flxc19ac1xq3m3wyq1w9p3pab"))))
       ("unzip" ,unzip)))
    (inputs
     `(("font-dejavu" ,font-dejavu)
       ("glew" ,glew)
       ("libpng" ,libpng)
       ("sdl-union" ,(sdl-union (list sdl
                                      sdl-gfx
                                      sdl-mixer
                                      sdl-ttf)))))
    (home-page "http://www.roguetemple.com/z/hyper/")
    (synopsis "Non-euclidean graphical rogue-like game")
    (description
     "HyperRogue is a game in which the player collects treasures and fights
monsters -- rogue-like but for the fact that it is played on the hyperbolic
plane and not in euclidean space.

In HyperRogue, the player can move through different parts of the world, which
are home to particular creatures and may be subject to their own rules of
\"physics\".

While the game can use ASCII characters to display the the classical rogue
symbols, it still needs graphics to render the non-euclidean world.")
    (license (list license:bsd-3         ; glew.c, mtrand.*
                   license:cc-by-sa3.0   ; music
                   license:cc-by-sa4.0   ; sounds
                   license:cc0
                   license:public-domain ; direntx.*, some sounds
                   license:zlib          ; savepng.*
                   license:gpl2+))))     ; remaining files

(define-public kobodeluxe
  (package
    (name "kobodeluxe")
    (version "0.5.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://olofson.net/kobodl/download/KoboDeluxe-"
                                  version ".tar.bz2"))
              (sha256
               (base32
                "0b2wvdpnmaibsy419c16dfwj5kvd3pccby2aaqvm964x74592yqg"))
              (patches (search-patches
                        "kobodeluxe-const-charp-conversion.patch"
                        "kobodeluxe-enemies-pipe-decl.patch"
                        "kobodeluxe-graphics-window-signed-char.patch"
                        "kobodeluxe-manpage-minus-not-hyphen.patch"
                        "kobodeluxe-midicon-segmentation-fault.patch"
                        "kobodeluxe-paths.patch"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       (list (string-append "CPPFLAGS=-I"
                            (assoc-ref %build-inputs "sdl-union")
                            "/include/SDL"))))
    (inputs `(("sdl-union" ,(sdl-union (list sdl sdl-image)))))
    (synopsis "Shooter with space station destruction")
    (description
     "Kobo Deluxe is an enhanced version of Akira Higuchi's XKobo graphical game
for Un*x systems with X11.")
    (home-page "http://olofson.net/kobodl/")
    (license license:gpl2+)))

(define-public freeciv
  (package
   (name "freeciv")
   (version "2.5.7")
   (source
    (origin
     (method url-fetch)
     (uri (list (string-append
                  "http://files.freeciv.org/stable/freeciv-"
                  version ".tar.bz2")
                (string-append
                  "mirror://sourceforge/freeciv/Freeciv%20"
                  (version-major+minor version) "/" version
                  "/freeciv-" version ".tar.bz2")))
     (sha256
      (base32
       "1lmydnnqraa947l7gdz6xgm0bgks1ywsivp9h4v8jr3avcv6gqzz"))))
   (build-system gnu-build-system)
   (inputs
    `(("curl" ,curl)
      ("cyrus-sasl" ,cyrus-sasl)
      ("gtk+" ,gtk+)
      ("sdl-mixer" ,sdl-mixer)
      ("zlib" ,zlib)))
   (native-inputs
    `(("pkg-config" ,pkg-config)))
   (home-page "http://www.freeciv.org/")
   (synopsis "Turn based empire building strategy game")
   (description "Freeciv is a turn based empire building strategy game
inspired by the history of human civilization.  The game commences in
prehistory and your mission is to lead your tribe from the Stone Age
to the Space Age.")
   (license license:gpl2+)))

(define-public no-more-secrets
  (package
    (name "no-more-secrets")
    (version "0.3.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/bartobri/no-more-secrets/"
                           "archive/v" version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1kpx1rirc3i7fb4lymp0hx5rqr0s2ay4za261rw3bcy6d23l1kyg"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:make-flags (list "CC=gcc" "all-ncurses"
                          (string-append "prefix="
                                         (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (inputs
     `(("ncurses" ,ncurses)))
    (home-page "https://github.com/bartobri/no-more-secrets")
    (synopsis "Recreation of data decryption effect in \"Sneakers\"")
    (description
     "@code{No More Secrets} provides a command line tool called \"nms\"
that recreates the famous data decryption effect seen on screen in the 1992
movie \"Sneakers\".

This command works on piped data.  Pipe any ASCII or UTF-8 text to nms, and
it will apply the hollywood effect, initially showing encrypted data, then
starting a decryption sequence to reveal the original plaintext characters.")
    (license license:expat)))

(define-public megaglest-data
  (package
    (name "megaglest-data")
    (version "3.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/MegaGlest/megaglest-data"
             "/releases/download/" version "/megaglest-data-"
             version ".tar.xz"))
       (sha256
        (base32
         "0ipgza33z89fw3si32iafm981f3fvm0zldvbxj29whghd2k3rpj3"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f))
    (home-page "https://megaglest.org/")
    (synopsis "Data files for MegaGlest")
    (description "This package contains the data files required for MegaGlest.")
    (license license:cc-by-sa3.0)))

(define-public megaglest
  (package
    (name "megaglest")
    (version "3.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/MegaGlest/megaglest-source"
             "/releases/download/" version "/megaglest-source-"
             version ".tar.xz"))
       (sha256
        (base32
         "1ffck3ii1wp5k3nn5p0ga06jgp7pzk4zw0xln3xim2w7qrxzdzh9"))))
    (build-system cmake-build-system)
    (inputs
     `(("curl" ,curl)
       ("fontconfig" ,fontconfig)
       ("ftgl" ,ftgl)
       ("glew" ,glew)
       ("libjpeg-turbo" ,libjpeg-turbo)
       ("megaglest-data" ,megaglest-data)
       ("mesa" ,mesa)
       ("miniupnpc" ,miniupnpc)
       ("openal" ,openal)
       ("libircclient" ,libircclient)
       ("libpng" ,libpng)
       ("libvorbis" ,libvorbis)
       ("lua" ,lua)
       ("sdl2" ,sdl2)
       ("wxwidgets" ,wxwidgets)))
    (native-inputs
     `(("cppunit" ,cppunit)
       ("pkg-config" ,pkg-config)))
    (arguments
     `(#:configure-flags
       (list (string-append "-DCUSTOM_DATA_INSTALL_PATH="
                            (assoc-ref %build-inputs "megaglest-data")
                            "/share/megaglest")
             "-DBUILD_MEGAGLEST_TESTS=ON")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-ini-search-path
                    (lambda* (#:key outputs #:allow-other-keys)
                      (substitute* "source/glest_game/global/config.cpp"
                        (("/usr/share/megaglest/")
                         (string-append (assoc-ref outputs "out")
                                        "/share/megaglest/"))))))
       #:test-target "megaglest_tests"))
    (home-page "https://megaglest.org/")
    (synopsis "3D real-time strategy (RTS) game")
    (description "MegaGlest is a cross-platform 3D real-time strategy (RTS)
game, where you control the armies of one of seven different factions: Tech,
Magic, Egypt, Indians, Norsemen, Persian or Romans.")
    (license license:gpl2+)))

(define-public freegish
  (let ((commit "8795cd7adc95957883f2d3465eb9036a774667a7")
        (revision "1"))
    (package
      (name "freegish")
      (version (string-append "0-" revision "." (string-take commit 9)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/freegish/freegish.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1p1zf5qqagmcpi1db2bs02cnalpy3qiymp6yzan7k1bhmv859gsx"))
                (modules '((guix build utils)))
                ;; The audio files in the "music" directory are licensed under
                ;; CC-BY-NC, so we delete them.
                (snippet
                 '(begin
                    (delete-file-recursively "music")
                    #t))))
      (build-system cmake-build-system)
      (arguments
       `(#:tests? #f ; no tests included
         #:configure-flags
         (list "-DCMAKE_INSTALL_FHS=ON")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'set-DATAPATH
             (lambda* (#:key outputs #:allow-other-keys)
               (substitute* "CMakeLists.txt"
                 (("^option\\(INSTALL_FHS" line)
                  (string-append "add_definitions(-DDATAPATH=\""
                                 (assoc-ref outputs "out") "/share/freegish\")\n"
                                 line)))
               #t)))))
      (inputs
       `(("sdl-union" ,(sdl-union (list sdl sdl-mixer)))
         ("openal" ,openal)
         ("libvorbis" ,libvorbis)
         ("libogg" ,libogg)
         ("mesa" ,mesa)
         ("libpng" ,libpng)
         ("zlib" ,zlib)))
      (home-page "https://github.com/freegish/freegish")
      (synopsis "Side-scrolling physics platformer with a ball of tar")
      (description "In FreeGish you control Gish, a ball of tar who lives
happily with his girlfriend Brea, until one day a mysterious dark creature
emerges from a sewer hole and pulls her below ground.")
      ;; The textures are available under the Expat license.  All other assets
      ;; (including levels) are covered under CC-BY-SA or public domain.  The
      ;; source code is under GPLv2+.
      (license (list license:gpl2+
                     license:expat
                     license:public-domain
                     license:cc-by-sa3.0)))))

(define-public cdogs-sdl
  ;; XXX: Use version 0.6.7 when it's available.
  (let ((commit "bab2031369b9ea2dbeb7eedbde10a43dd8ca83db")
        (revision "1"))
   (package
     (name "cdogs-sdl")
     (version (git-version "0.6.6" revision commit))
     (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/cxong/cdogs-sdl.git")
                     (commit commit)))
               (file-name (git-file-name name version))
               (sha256
                (base32
                 "09sfqhrrffhvxbhigvrxfmai52w01w3f9kjmixjhqvqlkhn77c9n"))))
     (build-system cmake-build-system)
     (arguments
      `(#:configure-flags
        (list (string-append "-DCDOGS_DATA_DIR="
                             (assoc-ref %outputs "out")
                             "/share/cdogs-sdl/"))))
     (inputs
      `(("mesa" ,mesa)
        ("sdl2" ,sdl2)
        ("sdl2-image" ,sdl2-image)
        ("sdl2-mixer" ,sdl2-mixer)))
     (home-page "https://cxong.github.io/cdogs-sdl/")
     (synopsis "Classic overhead run-and-gun game")
     (description "C-Dogs SDL is a classic overhead run-and-gun game,
supporting up to 4 players in co-op and deathmatch modes.  Customize your
player, choose from many weapons, and blast, slide and slash your way through
over 100 user-created campaigns.")
     ;; GPLv2+ for code (includes files under BSD-2 and BSD-3),
     ;; CC0/CC-BY/CC-BY-SA for assets.
     (license (list license:gpl2+
                    license:bsd-2
                    license:bsd-3
                    license:cc0
                    license:cc-by3.0
                    license:cc-by-sa3.0)))))

(define-public kiki
  (package
    (name "kiki")
    (version "1.0.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/kiki/kiki-src/"
                                  version "/kiki-" version "-src.tgz"))
              (sha256
               (base32
                "0ihjdsxbn8z3cz0gpcprafiipcqaiskgdnh1rhmw4qff8dszalbn"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (for-each delete-file (find-files "." "\\.dll$"))
                  #t))
              (patches
               (search-patches "kiki-level-selection-crash.patch"
                               "kiki-makefile.patch"
                               "kiki-missing-includes.patch"
                               "kiki-portability-64bit.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; there are no tests
       #:make-flags '("CXX=g++")
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (setenv "CPLUS_INCLUDE_PATH"
                     (string-append (assoc-ref inputs "sdl-union")
                                    "/include/SDL:"
                                    (assoc-ref inputs "python")
                                    "/include/python2.7:"
                                    (getenv "CPLUS_INCLUDE_PATH")))
             (substitute* "src/main/main.cpp"
               (("#include <SDL.h>" line)
                (string-append line "
#define K_INCLUDE_GLUT
#include \"KIncludeTools.h\""))
               (("// initialize SDL" line)
                (string-append "glutInit(&argc,argv);\n" line)))
             (substitute* "src/main/KikiController.cpp"
               (("getenv\\(\"KIKI_HOME\"\\)")
                (string-append "\"" (assoc-ref outputs "out") "/share/kiki/\"")))
             (substitute* "linux/Makefile"
               (("CXXOPTS =" line)
                (string-append line " -fpermissive"))
               (("PYTHON_VERSION=.*") "PYTHON_VERSION=2.7")
               (("PYTHONHOME =.*")
                (string-append "PYTHONHOME = "
                               (assoc-ref inputs "python")
                               "/lib/python2.7/"))
               (("\\$\\(GLLIBS\\)" line)
                (string-append line " -lm -lpython2.7")))
             (substitute* "src/main/KikiPythonWidget.h"
               (("#define __KikiPythonWidget" line)
                (string-append line "\n#include \"KikiPython.h\"")))
             #t))
         (add-before 'build 'build-kodilib
           (lambda* (#:key make-flags #:allow-other-keys)
             (with-directory-excursion "kodilib/linux"
               (zero? (apply system* "make" make-flags)))))
         (add-after 'build-kodilib 'chdir
           (lambda _ (chdir "linux") #t))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out   (assoc-ref outputs "out"))
                    (bin   (string-append out "/bin"))
                    (share (string-append out "/share/kiki")))
               (mkdir-p bin)
               (mkdir-p share)
               (install-file "kiki" bin)
               (copy-recursively "../py" (string-append share "/py"))
               (copy-recursively "../sound" (string-append share "/sound"))
               #t))))))
    (inputs
     `(("glu" ,glu)
       ;; Kiki builds fine with freeglut 3.0.0 but segfaults on start.
       ("freeglut" ,freeglut-2.8)
       ("sdl-union" ,(sdl-union (list sdl
                                      sdl-mixer
                                      sdl-image)))
       ("python" ,python-2)))
    (native-inputs
     `(("swig" ,swig)))
    (home-page "http://kiki.sourceforge.net/")
    (synopsis "3D puzzle game")
    (description "Kiki the nano bot is a 3D puzzle game.  It is basically a
mixture of the games Sokoban and Kula-World.  Your task is to help Kiki, a
small robot living in the nano world, repair its maker.")
    ;; See <http://metadata.ftp-master.debian.org/changelogs/main/k/
    ;; kiki-the-nano-bot/kiki-the-nano-bot_1.0.2+dfsg1-4_copyright>
    ;; for a statement from the author.
    (license license:public-domain)))

(define-public teeworlds
  (package
    (name "teeworlds")
    (version "0.6.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/teeworlds/teeworlds/"
                                  "archive/" version "-release.tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1mqhp6xjl75l49050cid36wxyjn1qr0vjx1c709dfg1lkvmgs6l3"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (for-each delete-file-recursively
                            '("src/engine/external/wavpack/"
                              "src/engine/external/zlib/"))
                  #t))
              (patches
               (search-patches "teeworlds-use-latest-wavpack.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no tests included
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Embed path to assets.
             (substitute* "src/engine/shared/storage.cpp"
               (("#define DATA_DIR.*")
                (string-append "#define DATA_DIR \""
                               (assoc-ref outputs "out")
                               "/share/teeworlds/data"
                               "\"")))

             ;; Bam expects all files to have a recent time stamp.
             (for-each (lambda (file)
                         (utime file 1 1))
                       (find-files "."))

             ;; Do not use bundled libraries.
             (substitute* "bam.lua"
               (("if config.zlib.value == 1 then")
                "if true then")
               (("wavpack = .*")
                "wavpack = {}
settings.link.libs:Add(\"wavpack\")\n"))
             (substitute* "src/engine/client/sound.cpp"
               (("#include <engine/external/wavpack/wavpack.h>")
                "#include <wavpack/wavpack.h>"))
             #t))
         (replace 'build
           (lambda _
             (zero? (system* "bam" "-a" "-v" "release"))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out  (assoc-ref outputs "out"))
                    (bin  (string-append out "/bin"))
                    (data (string-append out "/share/teeworlds/data")))
               (mkdir-p bin)
               (mkdir-p data)
               (for-each (lambda (file)
                           (install-file file bin))
                         '("teeworlds" "teeworlds_srv"))
               (copy-recursively "data" data)
               #t))))))
    ;; FIXME: teeworlds bundles the sources of "pnglite", a two-file PNG
    ;; library without a build system.
    (inputs
     `(("freetype" ,freetype)
       ("glu" ,glu)
       ("mesa" ,mesa)
       ("sdl-union" ,(sdl-union (list sdl
                                      sdl-mixer
                                      sdl-image)))
       ("wavpack" ,wavpack)
       ("zlib" ,zlib)))
    (native-inputs
     `(("bam" ,bam)
       ("python" ,python-2)))
    (home-page "https://www.teeworlds.com")
    (synopsis "2D retro multiplayer shooter game")
    (description "Teeworlds is an online multiplayer game.  Battle with up to
16 players in a variety of game modes, including Team Deathmatch and Capture
The Flag.  You can even design your own maps!")
    (license license:bsd-3)))

(define-public enigma
  (package
    (name "enigma")
    (version "1.21")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/enigma-game/"
                                  "Release%20" version "/enigma-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "00ffh9pypj1948pg3q9sjp1nmiabh52p5c8wpg9n1dcfgl3cywnq"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list "--with-system-enet")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'find-sdl
           (lambda _
             (substitute* "configure"
               (("SDL_ttf.h") "SDL/SDL_ttf.h"))
             (substitute* '("tools/ttf2bmf.cc"
                            "lib-src/enigma-core/ecl_font.cc"
                            "lib-src/enigma-core/ecl_video.cc"
                            "lib-src/enigma-core/ecl_buffer.hh"
                            "src/SoundEngine.cc"
                            "src/SoundEngine.hh"
                            "src/MusicManager.cc"
                            "src/MusicManager.hh"
                            "src/d_models.cc"
                            "src/main.cc"
                            "src/network.cc")
               (("#include \"SDL_(image|ttf|mixer|types|syswm|mutex).h\"" line header)
                (string-append "#include \"SDL/SDL_" header ".h\"")))
             (substitute* "src/main.cc"
               (("#include <SDL_(image|ttf|mixer).h>" line header)
                (string-append "#include \"SDL/SDL_" header ".h\"")))
             #t)))))
    (inputs
     `(("xerces-c" ,xerces-c)
       ("sdl-union" ,(sdl-union (list sdl sdl-image sdl-mixer sdl-ttf)))
       ("curl" ,curl)
       ("enet" ,enet)))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("imagemagick" ,imagemagick)))
    (home-page "https://www.nongnu.org/enigma")
    (synopsis "Puzzle game with a dexterity component")
    (description "Enigma is a puzzle game with 550 unique levels.  The object
of the game is to find and uncover pairs of identically colored ‘Oxyd’ stones.
Simple?  Yes.  Easy?  Certainly not!  Hidden traps, vast mazes, laser beams,
and most of all, countless hairy puzzles usually block your direct way to the
Oxyd stones.  Enigma’s game objects (and there are hundreds of them, lest you
get bored) interact in many unexpected ways, and since many of them follow the
laws of physics (Enigma’s special laws of physics, that is), controlling them
with the mouse isn’t always trivial.")
    (license license:gpl2+)))

(define-public fillets-ng
  (package
    (name "fillets-ng")
    (version "1.0.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/fillets/"
                                  "Fish%20Fillets%20-%20Next%20Generation/"
                                  version "/fillets-ng-" version ".tar.gz"))
              (sha256
               (base32
                "1nljp75aqqb35qq3x7abhs2kp69vjcj0h1vxcpdyn2yn2nalv6ij"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list (string-append "--with-lua="
                            (assoc-ref %build-inputs "lua")))
       #:make-flags
       (list (string-append "CFLAGS=-I"
                            (assoc-ref %build-inputs "sdl-union")
                            "/include/SDL")
             (string-append "CXXFLAGS=-I"
                            (assoc-ref %build-inputs "sdl-union")
                            "/include/SDL"))
       #:phases
       (modify-phases %standard-phases
         ;; Lua 5.1 does not provide it.
         (add-after 'unpack 'do-not-link-with-lualib
           (lambda _
             (substitute* "configure"
               (("-llualib") ""))
             #t))
         (add-after 'install 'install-data
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((data (string-append (assoc-ref outputs "out")
                                        "/share/games/fillets-ng")))
               (mkdir-p data)
               (zero? (system* "tar" "-xvf"
                               (assoc-ref inputs "fillets-ng-data")
                               "--strip-components=1"
                               "-C" data))))))))
    (inputs
     `(("sdl-union" ,(sdl-union (list sdl
                                      sdl-mixer
                                      sdl-image
                                      sdl-ttf)))
       ("fribidi" ,fribidi)
       ("libx11" ,libx11)
       ("lua" ,lua-5.1)))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("fillets-ng-data"
        ,(origin
           (method url-fetch)
           (uri (string-append "mirror://sourceforge/fillets/"
                               "Fish%20Fillets%20-%20Next%20Generation/"
                               version "/fillets-ng-data-" version ".tar.gz"))
           (sha256
            (base32
             "169p0yqh2gxvhdilvjc2ld8aap7lv2nhkhkg4i1hlmgc6pxpkjgh"))))))
    (home-page "http://fillets.sourceforge.net/")
    (synopsis "Puzzle game")
    (description "Fish Fillets NG is strictly a puzzle game.  The goal in
every of the seventy levels is always the same: find a safe way out.  The fish
utter witty remarks about their surroundings, the various inhabitants of their
underwater realm quarrel among themselves or comment on the efforts of your
fish.  The whole game is accompanied by quiet, comforting music.")
    (license license:gpl2+)))

(define-public crawl
  (package
    (name "crawl")
    (version "0.21.0")
    (source
     (origin
       (method url-fetch)
       (uri (list
             ;; Older releases get moved into a versioned directory
             (string-append "http://crawl.develz.org/release/"
                            (version-major+minor version) "/stone_soup-"
                            version "-nodeps.tar.xz")
             ;; Only the latest release is in this directory
             (string-append "http://crawl.develz.org/release/stone_soup-"
                            version "-nodeps.tar.xz")))
       (sha256
        (base32
         "0mmnkch8s9l7dh136yjvcyjr0vmyzv7z370rlcyir91qz6gg82n1"))
       (patches (search-patches "crawl-upgrade-saves.patch"))))
    (build-system gnu-build-system)
    (inputs
     `(("lua51" ,lua-5.1)
       ("ncurses" ,ncurses)
       ("sqlite" ,sqlite)
       ("zlib" ,zlib)))
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)))
    (arguments
     '(#:make-flags
       (let* ((sqlite (assoc-ref %build-inputs "sqlite"))
              (out (assoc-ref %outputs "out")))
         (list (string-append "SQLITE_INCLUDE_DIR=" sqlite "/include")
               (string-append "prefix=" out)
               "SAVEDIR=~/.crawl"
               ;; don't build any bundled dependencies
               "BUILD_LUA="
               "BUILD_SQLITE="
               "BUILD_ZLIB="
               "-Csource"))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check)
         ;; Test cases require the source to be rebuild with the -DDEBUG define.
         ;; Do 'check before 'build to avoid a 3rd build on make install.
         (add-before 'build 'check
           (lambda* (#:key inputs outputs make-flags #:allow-other-keys)
             (setenv "HOME" (getcwd))
             ;; Fake a terminal for the test cases.
             (setenv "TERM" "xterm-256color")
             (zero? (apply system* "make" "debug" "test"
                           (format #f "-j~d" (parallel-job-count))
                           ;; Force command line build for test cases.
                           (append make-flags '("GAME=crawl" "TILES=")))))))))
    (synopsis "Roguelike dungeon crawler game")
    (description "Dungeon Crawl Stone Soup is a roguelike adventure through
dungeons filled with dangerous monsters in a quest to find the mystifyingly
fabulous Orb of Zot.")
    (home-page "https://crawl.develz.org")
    (license (list license:gpl2+
                   license:bsd-2
                   license:bsd-3
                   license:cc0
                   license:expat
                   license:zlib
                   license:asl2.0))))

;; The linter here claims that patch file names should start with the package
;; name. But, in this case, the patches are inherited from crawl with the
;; "crawl-" prefix instead of "crawl-tiles-".
(define-public crawl-tiles
  (package
    (inherit crawl)
    (name "crawl-tiles")
    (arguments
     (substitute-keyword-arguments
         (package-arguments crawl)
       ((#:make-flags flags)
        `(let ((dejavu (assoc-ref %build-inputs "font-dejavu")))
           (cons*
            (string-append "PROPORTIONAL_FONT=" dejavu
                           "/share/fonts/truetype/DejaVuSans.ttf")
            (string-append "MONOSPACED_FONT=" dejavu
                           "/share/fonts/truetype/DejaVuSansMono.ttf")
            "TILES=y"
            ;; Rename the executable to allow parallel installation with crawl.
            "GAME=crawl-tiles"
            ,flags)))))
    (inputs
     `(,@(package-inputs crawl)
       ("font-dejavu" ,font-dejavu)
       ("freetype6" ,freetype)
       ("glu" ,glu)
       ("libpng" ,libpng)
       ("sdl2" ,sdl2)
       ("sdl2-image" ,sdl2-image)
       ("sdl2-mixer" ,sdl2-mixer)))
    (native-inputs
     `(,@(package-native-inputs crawl)
       ("pngcrush" ,pngcrush)
       ("which" ,which)))
    (synopsis "Graphical roguelike dungeon crawler game")))

(define-public lugaru
  (package
    (name "lugaru")
    (version "1.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://bitbucket.org/osslugaru/lugaru/downloads/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "15zgcshy22q51rm72zi6y9z7qlgnz5iw3gczjdlir4bqmxy4gspk"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       (list "-DSYSTEM_INSTALL=ON")
       ;; no test target
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("sdl2" ,sdl2)
       ("glu" ,glu)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("openal" ,openal)
       ("vorbis" ,libvorbis)
       ("zlib" ,zlib)))
    (home-page "https://osslugaru.gitlab.io")
    (synopsis "Cross-platform third-person action game")
    (description "Lugaru is a third-person action game.  The main character,
Turner, is an anthropomorphic rebel bunny rabbit with impressive combat skills.
In his quest to find those responsible for slaughtering his village, he uncovers
a far-reaching conspiracy involving the corrupt leaders of the rabbit republic
and the starving wolves from a nearby den.  Turner takes it upon himself to
fight against their plot and save his fellow rabbits from slavery.")
    (license (list license:gpl2+ ; code
                   ;; assets:
                   license:cc-by-sa3.0
                   license:cc-by-sa4.0))))

(define-public 0ad-data
  (package
    (name "0ad-data")
    (version "0.0.22-alpha")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://releases.wildfiregames.com/0ad-"
                           version "-unix-data.tar.xz"))
       (file-name (string-append name "-" version ".tar.xz"))
       (sha256
        (base32
         "0vknk9ay9h2p34r7mym2g066f3s3c5d5vmap0ckcs5b86h5cscjc"))
       (modules '((guix build utils)))
       (snippet
        #~(begin
            (for-each
             (lambda (name)
               (let* ((dir (string-append "binaries/data/mods/" name))
                      (file (string-append dir "/" name ".zip"))
                      (unzip #$(file-append unzip "/bin/unzip")))
                 (system* unzip "-d" dir file)
                 (delete-file file)))
             '("mod" "public"))
            #t))))
    (build-system trivial-build-system)
    (native-inputs `(("tar" ,tar)
                     ("xz" ,xz)))
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let ((out (assoc-ref %outputs "out"))
               (source (assoc-ref %build-inputs "source"))
               (tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar"))
               (xz-path (string-append (assoc-ref %build-inputs "xz") "/bin")))
           (setenv "PATH" xz-path)
           (mkdir out)
           (zero? (system* tar "xvf" source "-C" out "--strip=3"))))))
    (synopsis "Data files for 0ad")
    (description "0ad-data provides the data files required by the game 0ad.")
    (home-page "https://play0ad.com")
    (license (list (license:fsdg-compatible
                    "http://tavmjong.free.fr/FONTS/ArevCopyright.txt"
                    (license:license-comment
                     (package-license font-bitstream-vera)))
                   (package-license font-bitstream-vera)
                   license:cc-by-sa3.0
                   license:expat
                   license:gfl1.0
                   license:gpl2+
                   license:gpl3+))))

(define-public 0ad
  (package
    (name "0ad")
    (version "0.0.22-alpha")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://releases.wildfiregames.com/0ad-"
                           version "-unix-build.tar.xz"))
       (file-name (string-append name "-" version ".tar.xz"))
       (sha256
        (base32
         "1cgmr4g5g9wv36v7ylbrvqhsjwgcsdgbqwc8zlqmnayk9zgkdpgx"))
       ;; A snippet here would cause a build failure because of timestamps
       ;; reset.  See https://bugs.gnu.org/26734.
       ))
    (inputs
     `(("0ad-data" ,0ad-data)
       ("curl" ,curl)
       ("enet" ,enet)
       ("gloox" ,gloox)
       ("icu4c" ,icu4c)
       ("libpng" ,libpng)
       ("libvorbis" ,libvorbis)
       ("libxcursor" ,libxcursor)
       ("libxml2" ,libxml2)
       ("miniupnpc" ,miniupnpc)
       ("mozjs-38" ,mozjs-38)
       ("openal" ,openal)
       ("sdl2" ,sdl2)
       ("wxwidgets" ,wxwidgets)
       ("zlib" ,zlib)))
    (native-inputs
     `(("boost" ,boost)
       ("cmake" ,cmake)
       ("mesa" ,mesa)
       ("pkg-config" ,pkg-config)
       ("python-2" ,python-2)))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags '("config=release" "verbose=1" "-C" "build/workspaces/gcc")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'delete-bundles
           (lambda _
             (delete-file-recursively "libraries/source/spidermonkey")
             #t))
         (add-after 'unpack 'fix-x11-includes
           (lambda _
             (substitute* "source/lib/sysdep/os/unix/x/x.cpp"
               (("<Xlib.h>") "<X11/Xlib.h>"))
             (substitute* "source/lib/sysdep/os/unix/x/x.cpp"
               (("<Xatom.h>") "<X11/Xatom.h>"))
             (substitute* "source/lib/sysdep/os/unix/x/x.cpp"
               (("<Xcursor/Xcursor.h>") "<X11/Xcursor/Xcursor.h>"))
             #t))
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((jobs (number->string (parallel-job-count)))
                    (out (assoc-ref outputs "out"))
                    (lib (string-append out "/lib"))
                    (data (string-append out "/share/0ad")))
               (setenv "JOBS" (string-append "-j" jobs))
               (setenv "CC" "gcc")
               (with-directory-excursion "build/workspaces"
                 (zero? (system* "./update-workspaces.sh"
                                 (string-append "--libdir=" lib)
                                 (string-append "--datadir=" data)
                                 ;; TODO: "--with-system-nvtt"
                                 "--with-system-mozjs38"))))))
         (delete 'check)
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (chdir "binaries")
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (lib (string-append out "/lib"))
                    (data (string-append out "/share/0ad"))
                    (applications (string-append out "/share/applications"))
                    (pixmaps (string-append out "/share/pixmaps"))
                    (0ad-data (assoc-ref inputs "0ad-data")))
               ;; data
               (copy-recursively "data" data)
               (for-each (lambda (file)
                           (symlink (string-append 0ad-data "/" file)
                                    (string-append data "/" file)))
                         '("config" "mods/mod" "mods/public" "tools"))
               ;; libraries
               (for-each (lambda (file)
                           (install-file file lib))
                         (find-files "system" "\\.so$"))
               ;; binaries
               (install-file "system/pyrogenesis" bin)
               (with-directory-excursion bin
                 (symlink "pyrogenesis" "0ad"))
               ;; resources
               (with-directory-excursion "../build/resources"
                 (install-file "0ad.desktop" applications)
                 (install-file "0ad.png" pixmaps))
               #t)))
         (add-after 'install 'check
           (lambda _
             (with-directory-excursion "system"
               (zero? (system* "./test"))))))))
    (home-page "https://play0ad.com")
    (synopsis "3D real-time strategy game of ancient warfare")
    (description "0 A.D. is a real-time strategy (RTS) game of ancient
warfare.  It's a historically-based war/economy game that allows players to
relive or rewrite the history of twelve ancient civilizations, each depicted
at their peak of economic growth and military prowess.

0ad needs a window manager that supports 'Extended Window Manager Hints'.")
    (license (list license:bsd-2
                   license:bsd-3
                   license:expat
                   license:gpl2+
                   license:ibmpl1.0
                   license:isc
                   license:lgpl2.1
                   license:lgpl3
                   license:mpl2.0
                   license:zlib))))

;; There have been no official releases.
(define-public open-adventure
  (let* ((commit "d43854f0f6bb8e9eea7fbce80348150e7e7fc34d")
         (revision "2"))
    (package
      (name "open-adventure")
      (version (string-append "2.5-" revision "." (string-take commit 7)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://gitlab.com/esr/open-adventure")
                      (commit commit)))
                (file-name (string-append name "-" version "-checkout"))
                (sha256
                 (base32
                  "08bwrvf4axb1rsfd6ia1fddsky9pc1p350vjskhaakg2czc6dsk0"))))
      (build-system gnu-build-system)
      (arguments
       `(#:make-flags (list "CC=gcc")
         #:parallel-build? #f ; not supported
         #:phases
         (modify-phases %standard-phases
           (replace 'configure
             (lambda* (#:key inputs outputs #:allow-other-keys)
               ;; Linenoise is meant to be included, so we have to
               ;; copy it into the working directory.
               (let* ((linenoise (assoc-ref inputs "linenoise"))
                      (noisepath (string-append linenoise "/include/linenoise"))
                      (out (assoc-ref outputs "out")))
                 (copy-recursively noisepath "linenoise"))
               #t))
           (add-before 'build 'use-echo
             (lambda _
               (substitute* "tests/Makefile"
                 (("/bin/echo") (which "echo")))
               #t))
           (add-after 'build 'build-manpage
             (lambda _
               ;; This target is missing a dependency
               (substitute* "Makefile"
                 ((".adoc.6:" line)
                  (string-append line " advent.adoc")))
               (zero? (system* "make" ".adoc.6"))))
           ;; There is no install target
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (bin (string-append out "/bin"))
                      (man (string-append out "/share/man/man6")))
                 (install-file "advent" bin)
                 (install-file "advent.6" man))
               #t)))))
      (native-inputs
       `(("asciidoc" ,asciidoc)
         ("linenoise" ,linenoise)
         ("python" ,python)
         ("python-pyyaml" ,python-pyyaml)))
      (home-page "https://gitlab.com/esr/open-adventure")
      (synopsis "Colossal Cave Adventure")
      (description "The original Colossal Cave Adventure from 1976 was the
origin of all text adventures, dungeon-crawl (computer) games, and
computer-hosted roleplaying games.  This is the last version released by
Crowther & Woods, its original authors, in 1995.  It has been known as
\"adventure 2.5\" and \"430-point adventure\".")
      (license license:bsd-2))))

(define-public tome4
  (package
    (name "tome4")
    (version "1.5.5")
    (synopsis "Single-player, RPG roguelike game set in the world of Eyal")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://te4.org/dl/t-engine/t-engine4-src-"
                           version ".tar.bz2"))
       (sha256
        (base32
         "0v2qgdfpvdzd1bcbp9v8pfahj1bgczsq2d4xfhh5wg11jgjcwz03"))
       (modules '((guix build utils)))
       (snippet
        '(substitute* '("src/music.h" "src/tSDL.h")
           (("#elif defined(__FreeBSD__)" line)
            (string-append
             line " || defined(__GNUC__)"))))))
    (build-system gnu-build-system)
    (native-inputs
     `(("unzip" ,unzip)))
    (inputs
     `(("sdl-union" ,(sdl-union (list sdl2 sdl2-image sdl2-mixer sdl2-ttf)))
       ("glu" ,glu)
       ("premake4" ,premake4)
       ("openal" ,openal)
       ("vorbis" ,libvorbis)
       ("luajit" ,luajit)))
    (arguments
     `(#:make-flags '("CC=gcc" "config=release")
       #:phases (modify-phases %standard-phases
                  (replace 'configure
                    (lambda _
                      (zero? (system* "premake4" "gmake"))
                      #t))
                  (add-after 'set-paths 'set-sdl-paths
                    (lambda* (#:key inputs #:allow-other-keys)
                      (setenv "CPATH"
                              (string-append (assoc-ref inputs "sdl-union")
                                             "/include/SDL2"))
                      #t))
                  (delete 'check)
                  ;; premake doesn't provide install target
                  (replace 'install
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (usr (string-append out "/usr"))
                             (bin (string-append out "/bin"))
                             (licenses (string-append out "/share/licenses"))
                             (documents (string-append out "/share/doc"))
                             (pixmaps (string-append out "/share/pixmaps"))
                             (icon "te4-icon.png")
                             (data (string-append out "/share/" ,name))
                             (applications (string-append
                                            out "/share/applications"))
                             (unzip (string-append
                                     (assoc-ref inputs "unzip") "/bin/unzip"))
                             (wrapper (string-append bin "/" ,name)))
                        ;; icon
                        (mkdir-p pixmaps)
                        (system* unzip "-j"
                                 (string-append
                                  "game/engines/te4-" ,version ".teae")
                                 (string-append
                                  "data/gfx/" icon) "-d" pixmaps)
                        ;; game executable
                        (install-file "t-engine" data)
                        (mkdir-p bin)
                        (with-output-to-file wrapper
                          (lambda ()
                            (display
                             (string-append
                              "#!/bin/sh\n"
                              ;; No bootstrap code found,
                              ;; defaulting to working directory
                              ;; for engine code!
                              "cd " data "\n"
                              "exec -a tome4 ./t-engine \"$@\"\n"))))
                        (chmod wrapper #o555)
                        ;; licenses
                        (for-each (lambda (file)
                                    (install-file file licenses))
                                  '("COPYING" "COPYING-MEDIA"))
                        ;; documents
                        (for-each (lambda (file)
                                    (install-file file documents))
                                  '("CONTRIBUTING" "CREDITS"))
                        ;; data
                        (copy-recursively "bootstrap" (string-append
                                                       data "/bootstrap"))
                        (copy-recursively "game" (string-append data "/game"))
                        ;; launcher
                        (mkdir-p applications)
                        (with-output-to-file (string-append applications "/"
                                                            ,name ".desktop")
                          (lambda ()
                            (display
                             (string-append
                              "[Desktop Entry]
Name=ToME4
Comment=" ,synopsis "\n"
"Exec=" ,name "\n"
"Icon=" icon "\n"
"Terminal=false
Type=Application
Categories=Game;RolePlaying;\n")))))
                      #t)))))
    (home-page "https://te4.org")
    (description "Tales of Maj’Eyal (ToME) RPG, featuring tactical turn-based
combat and advanced character building.  Play as one of many unique races and
classes in the lore-filled world of Eyal, exploring random dungeons, facing
challenging battles, and developing characters with your own tailored mix of
abilities and powers.  With a modern graphical and customisable interface,
intuitive mouse control, streamlined mechanics and deep, challenging combat,
Tales of Maj’Eyal offers engaging roguelike gameplay for the 21st century.")
    (license license:gpl3+)))

(define-public quakespasm
  (package
    (name "quakespasm")
    (version "0.93.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/quakespasm/Source/quakespasm-"
                           version ".tgz"))
       (sha256
        (base32
         "0b2nz7w4za32pc34r62ql270z692qcjs2pm0i3svkxkvfammhdfq"))))
    (arguments
     `(#:tests? #f
       #:make-flags '("CC=gcc"
                      "MP3LIB=mpg123"
                      "USE_CODEC_FLAC=1"
                      "USE_CODEC_MIKMOD=1"
                      "USE_SDL2=1"
                      "-CQuake")
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-after 'unpack 'fix-makefile-paths
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((out (assoc-ref outputs "out")))
                        (mkdir-p (string-append out "/bin"))
                        (substitute* "Quake/Makefile"
                          (("/usr/local/games")
                           (string-append out "/bin")))
                        #t))))))
    (build-system gnu-build-system)
    (inputs `(("libmikmod" ,libmikmod)
              ("libvorbis" ,libvorbis)
              ("flac" ,flac)
              ("mesa" ,mesa)
              ("mpg123" ,mpg123)
              ("sdl2" ,sdl2)))
    (synopsis "First person shooter engine for Quake 1")
    (description "Quakespasm is a modern engine for id software's Quake 1.
It includes support for 64 bit CPUs, custom music playback, a new sound driver,
some graphical niceities, and numerous bug-fixes and other improvements.")
    (home-page "http://quakespasm.sourceforge.net/")
    (license license:gpl2+)))

(define-public vkquake
  (package
    (inherit quakespasm)
    (name "vkquake")
    (version "0.97.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/Novum/vkQuake/archive/"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1p0nh2v2ilylw62fxc5qpfcmyhs0s64w8sgh036nc6kn21kbjc0d"))))
    (arguments
     `(#:make-flags
       (let ((vulkanlib (string-append (assoc-ref %build-inputs
                                                  "vulkan-icd-loader") "/lib")))
         (list "CC=gcc"
               "MP3LIB=mpg123"
               "USE_CODEC_FLAC=1"
               "USE_CODEC_MIKMOD=1"
               "USE_SDL2=1"
               (string-append "LDFLAGS=-Wl,-rpath=" vulkanlib)
               "-CQuake"))
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-after 'unpack 'fix-makefile-paths
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((vulkan (assoc-ref %build-inputs
                                               "vulkan-icd-loader"))
                            (out (assoc-ref outputs "out")))
                        (mkdir-p (string-append out "/bin"))
                        (substitute* "Quake/Makefile" ((" /usr")
                                                       (string-append " " out)))
                        (substitute* "Quake/Makefile" (("/games")
                                                       (string-append "/bin")))
                        (substitute* "Quake/Makefile" (("..VULKAN_SDK.") vulkan))
                        #t))))
       ,@(strip-keyword-arguments '(#:make-flags #:phases)
                                  (package-arguments quakespasm))))
    (inputs `(("vulkan-icd-loader" ,vulkan-icd-loader)
              ,@(package-inputs quakespasm)))
    (description "vkquake is a modern engine for id software's Quake 1.
It includes support for 64 bit CPUs, custom music playback, a new sound driver,
some graphical niceities, and numerous bug-fixes and other improvements.")
    (home-page "https://github.com/Novum/vkQuake")))

(define-public yamagi-quake2
  (package
    (name "yamagi-quake2")
    (version "7.10")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://deponie.yamagi.org/quake2/quake2-"
                           version ".tar.xz"))
       (sha256
        (base32
         "0psinbg25mysd58k99s1n34w31w5hj1vppb39gdjb0zqi6sl6cps"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:make-flags
       (list "CC=gcc"
             ;; link openAL instead of using dlopen at runtime
             "DLOPEN_OPENAL=\"no\""
             ;; an optional directory where it will look for quake2 data files
             ;; in addition to the current working directory
             "WITH_SYSTEMWIDE=yes"
             "WITH_SYSTEMDIR=\"/opt/quake2\"")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (mkdir-p (string-append out "/lib"))
               (mkdir-p (string-append out "/bin"))
               ;; The yamagi-quake2 binary must be in the same directory
               ;; as it's engine libraries, but symlinking it to /bin is okay
               ;; https://github.com/yquake2/yquake2/blob/master/stuff/packaging.md
               (copy-recursively "release"
                                 (string-append out "/lib/yamagi-quake2"))
               (symlink (string-append out "/lib/yamagi-quake2/quake2")
                        (string-append out "/bin/yamagi-quake2"))
               (symlink (string-append out "/lib/yamagi-quake2/q2ded")
                        (string-append out "/bin/yamagi-q2ded"))))))))
    (inputs `(("sdl2" ,sdl2)
              ("mesa" ,mesa)
              ("libvorbis" ,libvorbis)
              ("zlib" ,zlib)
              ("openal" ,openal)))
    (native-inputs `(("pkg-config" ,pkg-config)))
    (synopsis "First person shooter engine based on quake2")
    (description "Yamagi Quake II is an enhanced client for id Software's Quake II.
The main focus is an unchanged single player experience like back in 1997,
thus the gameplay and the graphics are unaltered.  However the user may use one
of the unofficial retexturing packs.  In comparison with the official client,
over 1000 bugs were fixed and an extensive code audit done,
making Yamagi Quake II one of the most solid Quake II implementations available.")
    (home-page "https://www.yamagi.org/quake2/")
    (license (list license:gpl2+         ; game and server
                   (license:non-copyleft ; info-zip
                    "file://LICENSE"
                    "See Info-Zip section.")
                   license:public-domain)))) ; stb

(define-public the-butterfly-effect
  (package
    (name "the-butterfly-effect")
    (version "0.9.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/the-butterfly-effect/tbe/archive/"
             "v" version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "18qkp7fgdvyl3haqqa693mgyic7afsznsxgz98z9wn4csaqxsnby"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         ;; There is no "install" phase.  By default, tbe is installed
         ;; in the build directory.  Provide our own installation.
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (share (string-append out "/share")))
               (install-file "usr/games/tbe" bin)
               (mkdir-p share)
               (copy-recursively "usr/share" share)
               #t))))
       ;; Test suite requires a running Xorg server. Even when
       ;; provided, it fails with "D-Bus library appears to be
       ;; incorrectly set up; failed to read machine uuid: Failed to
       ;; open "/etc/machine-id": No such file or directory" along
       ;; with multiple "QPainter:: ... Painter not active" warnings.
       #:tests? #f))
    (inputs
     `(("qtbase" ,qtbase)
       ("qtsvg" ,qtsvg)))
    (native-inputs
     `(("cmake" ,cmake)
       ("gettext-minimal" ,gettext-minimal)
       ("qttools" ,qttools)))
    (synopsis "Realistic physics puzzle game")
    (description "The Butterfly Effect (tbe) is a game that uses
realistic physics simulations to combine lots of simple mechanical
elements to achieve a simple goal in the most complex way possible.")
    (home-page "http://the-butterfly-effect.org/")
    ;; Main license is GPL2-only.  However, artwork is distributed
    ;; under various licenses, listed here.
    (license (list license:gpl2 license:public-domain license:expat
                   license:cc-by-sa3.0 license:gpl3+ license:wtfpl2))))

(define-public pioneer
  (package
    (name "pioneer")
    (version "20180203")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pioneerspacesim/pioneer.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0hp2mf36kj2v93hka8m8lxw2qhmnjc62wjlpw7c7ix0r8xa01i6h"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("assimp" ,assimp)
       ("curl" ,curl)
       ("freetype" ,freetype)
       ("glu" ,glu)
       ("libpng" ,libpng)
       ("libsigc++" ,libsigc++)
       ("libvorbis" ,libvorbis)
       ("lua" ,lua-5.2)                 ;not compatible with 5.3
       ("mesa" ,mesa)
       ("sdl" ,(sdl-union (list sdl2 sdl2-image)))))
    (arguments
     `(#:tests? #f                      ;tests are broken
       #:configure-flags (list "--with-external-liblua"
                               (string-append "PIONEER_DATA_DIR="
                                              %output "/share/games/pioneer"))
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'bootstrap
                    (lambda _ (zero? (system* "sh" "bootstrap"))))
                  (add-before 'bootstrap 'fix-lua-check
                    (lambda _
                      (substitute* "configure.ac"
                        (("lua5.2")
                         (string-append "lua-" ,(version-major+minor
                                                 (package-version lua-5.2))))))))))
    (home-page "http://pioneerspacesim.net")
    (synopsis "Game of lonely space adventure")
    (description
     "Pioneer is a space adventure game set in our galaxy at the turn of the
31st century.  The game is open-ended, and you are free to eke out whatever
kind of space-faring existence you can think of.  Look for fame or fortune by
exploring the millions of star systems.  Turn to a life of crime as a pirate,
smuggler or bounty hunter.  Forge and break alliances with the various
factions fighting for power, freedom or self-determination.  The universe is
whatever you make of it.")
    (license license:gpl3)))

(define-public badass
  (let ((commit "3c3cd669b4fc8f73a102e3702788f7b28dc47dbb")
        (revision "0"))
  (package
    (name "badass")
    (version (git-version "0.0" revision commit))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/umayr/badass.git")
                     (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "05c9vdcb5ym3z0n5ll3v39mw4yl9jcjnlydmn0yl89ai9pv71zb6"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/umayr/badass"))
    (synopsis "Hacking contribution graphs in git")
    (description
     "Badass generates false commits for a range of dates, essentially
hacking the gamification of contribution graphs on platforms such as
Github or Gitlab.")
    (home-page "https://github.com/umayr/badass")
    (license license:expat))))

(define-public colobot
  (package
    (name "colobot")
    (version "0.1.11-alpha")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/colobot/colobot/archive/"
                           "colobot-gold-" version ".tar.gz"))
       (sha256
        (base32
         "160rq9fp5vd0qaqr3jvzvzrcxk9cac532y8vx4cvq0a8hgylrbad"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f                      ;no test
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'unpack-data
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((data (assoc-ref inputs "colobot-data")))
               (invoke "tar" "-xvf" data "-Cdata" "--strip-components=1")
               #t)))
         (add-after 'unpack-data 'install-music
           (lambda* (#:key inputs #:allow-other-keys)
             ;; Installation process tries to download music files using
             ;; "wget" if not already present.  Since we are going to install
             ;; them, skip "wget" command check.
             (substitute* "data/music/CMakeLists.txt"
               (("find_program\\(WGET wget\\)") ""))
             ;; Effectively install music.
             (let ((data (assoc-ref inputs "colobot-music")))
               (invoke "tar" "-xvf" data "-Cdata/music")
               #t)))
         (add-after 'install 'fix-install-directory
           ;; Move binary from "games/" to "bin/".
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (rename-file (string-append out "/games")
                            (string-append out "/bin"))
               #t))))))
    (native-inputs
     `(("colobot-data"
        ,(origin
           (method url-fetch)
           (uri (string-append
                 "https://github.com/colobot/colobot-data/archive/"
                 "colobot-gold-" version ".tar.gz"))
           (sha256
            (base32
             "1pdpsyr41g7xmk03k2g76l214f53ahk04qnkzmsv1fdbbaq7p109"))))
       ("colobot-music"
        ,(origin
           (method url-fetch)
           (uri (string-append "https://colobot.info/files/music/"
                               "colobot-music_ogg_" version ".tar.gz"))
           (sha256
            (base32
             "1s86cd36rwkff329mb1ay1wi5qqyi35564ppgr3f4qqz9wj9vs2m"))))
       ("gettext" ,gettext-minimal)
       ("librsvg" ,librsvg)
       ("po4a" ,po4a)
       ("python" ,python-wrapper)))
    (inputs
     `(("boost" ,boost)
       ("glew" ,glew)
       ("libogg" ,libogg)
       ("libpng" ,libpng)
       ("libsndfile" ,libsndfile)
       ("libvorbis" ,libvorbis)
       ("openal" ,openal)
       ("physfs" ,physfs)
       ("sdl" ,(sdl-union (list sdl2 sdl2-image sdl2-ttf)))))
    (synopsis "Educational programming strategy game")
    (description "Colobot: Gold Edition is a real-time strategy game, where
you can program your units (bots) in a language called CBOT, which is similar
to C++ and Java.  Your mission is to find a new planet to live and survive.
You can save humanity and get programming skills!")
    (home-page "https://colobot.info")
    (license license:gpl3+)))

(define-public gzdoom
  (package
    (name "gzdoom")
    (version "3.3.0")
    (source (origin
              (method url-fetch)
              (uri
               (string-append "https://zdoom.org/files/gzdoom/src/gzdoom-g"
                              version ".zip"))
              (sha256
               (base32
                "09a4kx3ry8pc9r578m7yprwa7zsdqxjpn10lyc92r5g9sx4l1m1a"))
              (patches (search-patches "gzdoom-search-in-installed-share.patch"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (delete-file-recursively "bzip2")
                  (delete-file-recursively "game-music-emu")
                  (delete-file-recursively "jpeg-6b")
                  (delete-file-recursively "zlib")))))
    (arguments
     '(#:tests? #f
       #:configure-flags
       (let ((out (assoc-ref %outputs "out")))
         (list
          (string-append
           "-DCMAKE_CXX_FLAGS:="
           "-DSHARE_DIR=\\\"" out "/share/\\\" "
           "-DGUIX_OUT_PK3=\\\"" out "/share/games/doom\\\"")
          ;; look for libraries at buildtime instead of
          ;; dynamically finding them at runtime
          "-DDYN_OPENAL=OFF"
          "-DDYN_FLUIDSYNTH=OFF"
          "-DDYN_GTK=OFF"
          "-DDYN_MPG123=OFF"
          "-DDYN_SNDFILE=OFF"))
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-referenced-paths
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((fluid-3 (assoc-ref inputs "fluid-3"))
                   (timidity++ (assoc-ref inputs "timidity++"))
                   (out (assoc-ref outputs "out")))

               (substitute*
                   "src/CMakeLists.txt"
                 (("COMMAND /bin/sh")
                  (string-append "COMMAND " (which "sh"))))

               (substitute*
                   "src/sound/mididevices/music_fluidsynth_mididevice.cpp"
                 (("/usr/share/sounds/sf2/FluidR3_GM.sf2")
                  (string-append fluid-3 "/share/soundfonts/FluidR3Mono_GM.sf3")))

               (substitute*
                   "src/sound/mididevices/music_timiditypp_mididevice.cpp"
                 (("exename = \"timidity\"")
                  (string-append "exename = \"" timidity++ "/bin/timidity\"")))
               #t))))))
    (build-system cmake-build-system)
    (inputs `(("bzip2" ,bzip2)
              ("fluid-3" ,fluid-3)
              ("fluidsynth" ,fluidsynth)
              ("gtk+3" ,gtk+)
              ("libgme" ,libgme)
              ("libjpeg" ,libjpeg)
              ("libsndfile" ,libsndfile)
              ("mesa" ,mesa)
              ("mpg123" ,mpg123)
              ("openal" ,openal)
              ("sdl2" ,sdl2)
              ("timidity++" ,timidity++)
              ("zlib" ,zlib)))
    (native-inputs `(("pkg-config" ,pkg-config)
                     ("unzip" ,unzip)))
    (synopsis "Modern Doom 2 source port")
    (description "GZdoom is a port of the Doom 2 game engine, with a modern
renderer.  It improves modding support with ZDoom's advanced mapping features
and the new ZScript language.  In addition to Doom, it supports Heretic, Hexen,
Strife, Chex Quest, and fan-created games like Harmony, Hacx and Freedoom.")
    (home-page "https://zdoom.org/index")
    (license (list license:gpl3+         ; gzdoom game
                   license:lgpl3+        ; gzdoom renderer
                   license:expat         ; gdtoa
                   (license:non-copyleft ; modified dumb
                    "file://dumb/licence.txt"
                    "Dumb license, explicitly GPL compatible.")))))

(define-public fortune-mod
  (package
    (name "fortune-mod")
    (version "2.4.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/shlomif/fortune-mod/"
                                  "archive/" name "-" version ".tar.gz"))
              (sha256
               (base32
                "1hnqpkassh7fwg2jgvybr8mw7vzfikbrhb5r22367ilfwxnl9yd2"))))
    (build-system cmake-build-system)
    (arguments
     `(#:test-target "check"
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-build-env
           (lambda* (#:key inputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((cmake-rules (assoc-ref inputs "cmake-rules")))
               (copy-file cmake-rules
                          (string-append "fortune-mod/cmake/"
                                         (strip-store-file-name cmake-rules)))
               (chdir "fortune-mod"))))
         (add-after 'install 'fix-install-directory
           ;; Move binary from "games/" to "bin/".
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (rename-file (string-append out "/games/fortune")
                            (string-append out "/bin/fortune"))
               #t))))))
    (inputs `(("recode" ,recode)))
    (native-inputs
     `(("perl" ,perl)
       ;; The following is only needed for tests.
       ("perl-file-find-object" ,perl-file-find-object)
       ("perl-test-differences" ,perl-test-differences)
       ("perl-class-xsaccessor" ,perl-class-xsaccessor)
       ("perl-io-all" ,perl-io-all)
       ("perl-test-runvalgrind" ,perl-test-runvalgrind)
       ("cmake-rules"
        ,(origin
           (method url-fetch)
           (uri (string-append "https://bitbucket.org/shlomif/shlomif-cmake-modules/"
                               "raw/c505713d7a7cda608f97f01577e5868a711b883e/"
                               "shlomif-cmake-modules/Shlomif_Common.cmake"))
           (sha256
            (base32 "0kx9s1qqhhzprp1w3b67xmsns0n0v506bg5hgrshxaxpy6lqiwb2"))))))
    (home-page "http://www.shlomifish.org/open-source/projects/fortune-mod/")
    (synopsis "The Fortune Cookie program from BSD games")
    (description "Fortune is a command-line utility which displays a random
quotation from a collection of quotes.")
    (license license:bsd-4)))
