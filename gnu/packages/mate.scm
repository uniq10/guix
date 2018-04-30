;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Fabian Harfert <fhmgufs@web.de>
;;; Copyright © 2016, 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017 Nils Gillmann <ng0@n0.is>
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

(define-module (gnu packages mate)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages attr)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages djvu)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages enchant)
  #:use-module (gnu packages file)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages iso-codes)
  #:use-module (gnu packages javascript)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages nettle)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages photo)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg))

(define-public mate-common
  (package
    (name "mate-common")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1005laf3z1h8qczm7pmwr40r842665cv6ykhjg7r93vldra48z6p"))))
    (build-system gnu-build-system)
    (home-page "https://mate-desktop.org/")
    (synopsis "Common files for development of MATE packages")
    (description
     "Mate Common includes common files and macros used by
MATE applications.")
    (license license:gpl3+)))

(define-public mate-icon-theme
  (package
    (name "mate-icon-theme")
    (version "1.18.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pub.mate-desktop.org/releases/"
                                  (version-major+minor version) "/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "0si3li3kza7s45zhasjvqn5f85zpkn0x8i4kq1dlnqvjjqzkg4ch"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("icon-naming-utils" ,icon-naming-utils)))
    (home-page "https://mate-desktop.org/")
    (synopsis "The MATE desktop environment icon theme")
    (description
     "This package contains the default icon theme used by the MATE desktop.")
    (license license:lgpl3+)))

(define-public mate-icon-theme-faenza
  (package
    (name "mate-icon-theme-faenza")
    (version "1.18.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pub.mate-desktop.org/releases/"
                                  (version-major+minor version) "/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "0vc3wg9l5yrxm0xmligz4lw2g3nqj1dz8fwv90xvym8pbjds2849"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'autoconf
           (lambda _
             (setenv "SHELL" (which "sh"))
             (setenv "CONFIG_SHELL" (which "sh"))
             (invoke "sh" "autogen.sh"))))))
    (native-inputs
     `(("autoconf" ,autoconf-wrapper)
       ("automake" ,automake)
       ("intltool" ,intltool)
       ("icon-naming-utils" ,icon-naming-utils)
       ("libtool" ,libtool)
       ("mate-common" ,mate-common)
       ("pkg-config" ,pkg-config)
       ("which" ,which)))
    (home-page "https://mate-desktop.org/")
    (synopsis "MATE desktop environment icon theme faenza")
    (description
     "Icon theme using Faenza and Faience icon themes and some
customized icons for MATE.  Furthermore it includes some icons
from Mint-X-F and Faenza-Fresh icon packs.")
    (license license:gpl2+)))

(define-public mate-themes
  (package
    (name "mate-themes")
    (version "3.22.16")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pub.mate-desktop.org/releases/themes/"
                                  (version-major+minor version) "/mate-themes-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1k8qp2arjv4vj8kyjhjgyj5h46jy0darlfh48l5h25623z1firdj"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gdk-pixbuf" ,gdk-pixbuf) ; gdk-pixbuf+svg isn't needed
       ("gtk" ,gtk+-2)))
    (home-page "https://mate-desktop.org/")
    (synopsis
     "Official themes for the MATE desktop")
    (description
     "This package includes the standard themes for the MATE desktop, for
example Menta, TraditionalOk, GreenLaguna or BlackMate.  This package has
themes for both gtk+-2 and gtk+-3.")
    (license (list license:lgpl2.1+ license:cc-by-sa3.0 license:gpl3+
                   license:gpl2+))))

(define-public mate-desktop
  (package
    (name "mate-desktop")
    (version "1.18.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pub.mate-desktop.org/releases/"
                                  (version-major+minor version) "/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "12iv2y4dan962fs7vkkxbjkp77pbvjnwfa43ggr0zkdsc3ydjbbg"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("glib:bin" ,glib "bin")
       ("gobject-introspection" ,gobject-introspection)
       ("yelp-tools" ,yelp-tools)
       ("gtk-doc" ,gtk-doc)))
    (inputs
     `(("gtk+" ,gtk+)
       ("libxrandr" ,libxrandr)
       ("startup-notification" ,startup-notification)))
    (propagated-inputs
     `(("dconf" ,dconf))) ; mate-desktop-2.0.pc
    (home-page "https://mate-desktop.org/")
    (synopsis "Library with common API for various MATE modules")
    (description
     "This package contains a public API shared by several applications on the
desktop and the mate-about program.")
    (license (list license:gpl2+ license:lgpl2.0+ license:fdl1.1+))))

(define-public libmateweather
  (package
    (name "libmateweather")
    (version "1.18.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pub.mate-desktop.org/releases/"
                                  (version-major+minor version) "/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "0z6vfh42fv9rqjrraqfpf6h9nd9h662bxy3l3r48j19xvxrwmx3a"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       (list (string-append "--with-zoneinfo-dir="
                            (assoc-ref %build-inputs "tzdata")
                            "/share/zoneinfo"))
       #:phases
       (modify-phases %standard-phases
         (add-before 'check 'fix-tzdata-location
          (lambda* (#:key inputs #:allow-other-keys)
            (substitute* "data/check-timezones.sh"
              (("/usr/share/zoneinfo/zone.tab")
               (string-append (assoc-ref inputs "tzdata")
                              "/share/zoneinfo/zone.tab")))
            #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("dconf" ,dconf)
       ("glib:bin" ,glib "bin")))
    (inputs
     `(("gtk+" ,gtk+)
       ("tzdata" ,tzdata)))
    (propagated-inputs
      ;; both of these are requires.private in mateweather.pc
     `(("libsoup" ,libsoup)
       ("libxml2" ,libxml2)))
    (home-page "https://mate-desktop.org/")
    (synopsis "MATE library for weather information from the Internet")
    (description
     "This library provides access to weather information from the internet for
the MATE desktop environment.")
    (license license:lgpl2.1+)))

(define-public mate-terminal
  (package
    (name "mate-terminal")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1zihm609d2d9cw53ry385whshjl1dnkifpk41g1ddm9f58hv4da1"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("itstool" ,itstool)
       ("gobject-introspection" ,gobject-introspection)
       ("libxml2" ,libxml2)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("dconf" ,dconf)
       ("gtk+" ,gtk+)
       ("libice" ,libice)
       ("libsm" ,libsm)
       ("libx11" ,libx11)
       ("mate-desktop" ,mate-desktop)
       ("pango" ,pango)
       ("vte" ,vte)))
    (home-page "https://mate-desktop.org/")
    (synopsis "MATE Terminal Emulator")
    (description
     "MATE Terminal is a terminal emulation application that you can
use to access a shell.  With it, you can run any application that
is designed to run on VT102, VT220, and xterm terminals.
MATE Terminal also has the ability to use multiple terminals
in a single window (tabs) and supports management of different
configurations (profiles).")
    (license license:gpl3)))

(define-public mate-session-manager
  (package
    (name "mate-session-manager")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0i0xq6041x2qmb26x9bawx0qpfkgjn6x9w3phnm9s7rc4s0z20ll"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list "--enable-elogind"
                               "--disable-schemas-compile")
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'pre-configure
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Use elogind instead of systemd.
             (substitute* "configure"
               (("libsystemd-login")
                "libelogind")
               (("systemd") "elogind"))
             (substitute* "mate-session/gsm-systemd.c"
               (("#include <systemd/sd-login.h>")
                "#include <elogind/sd-login.h>"))
             ;; Remove uses of the systemd journal.
             (substitute* "mate-session/main.c"
               (("#ifdef HAVE_SYSTEMD") "#if 0"))
             (substitute* "mate-session/gsm-manager.c"
               (("#ifdef HAVE_SYSTEMD") "#if 0"))
             (substitute* "mate-session/gsm-autostart-app.c"
               (("#ifdef HAVE_SYSTEMD") "#if 0"))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("xtrans" ,xtrans)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("gtk+" ,gtk+)
       ("dbus-glib" ,dbus-glib)
       ("elogind" ,elogind)
       ("libsm" ,libsm)
       ("mate-desktop" ,mate-desktop)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Session manager for MATE")
    (description
     "Mate-session contains the MATE session manager, as well as a
configuration program to choose applications starting on login.")
    (license license:gpl2)))

(define-public mate-settings-daemon
  (package
    (name "mate-settings-daemon")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "07b2jkxqv07njdrgkdck93d872p6lch1lrvi7ydnpicspg3rfid6"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("cairo" ,cairo)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("dconf" ,dconf)
       ("fontconfig" ,fontconfig)
       ("gtk+" ,gtk+)
       ("libcanberra" ,libcanberra)
       ("libmatekbd" ,libmatekbd)
       ("libmatemixer" ,libmatemixer)
       ("libnotify" ,libnotify)
       ("libx11" ,libx11)
       ("libxext" ,libxext)
       ("libxi" ,libxi)
       ("libxklavier" ,libxklavier)
       ("mate-desktop" ,mate-desktop)
       ("nss" ,nss)
       ("polkit" ,polkit)
       ("startup-notification" ,startup-notification)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Settings Daemon for MATE")
    (description
     "Mate-settings-daemon is a fork of gnome-settings-daemon.")
    (license (list license:lgpl2.1 license:gpl2))))

(define-public libmatemixer
  (package
    (name "libmatemixer")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "09vyxnlnalws318gsafdfi5c6jwpp92pbafn1ddlqqds23ihk4mr"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("glib" ,glib)
       ("pulseaudio" ,pulseaudio)
       ("alsa-lib" ,alsa-lib)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Mixer library for the MATE desktop")
    (description
     "Libmatemixer is a mixer library for MATE desktop.  It provides an abstract
API allowing access to mixer functionality available in the PulseAudio and ALSA
sound systems.")
    (license license:lgpl2.1)))

(define-public libmatekbd
  (package
    (name "libmatekbd")
    (version "1.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "030bl18qbjm7l92bp1bhs7v82bp8j3mv7c1j1a4gd89iz4611pq3"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("cairo" ,cairo)
       ("gdk-pixbuf" ,gdk-pixbuf+svg)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("libx11" ,libx11)
       ("libxklavier" ,libxklavier)))
    (home-page "https://mate-desktop.org/")
    (synopsis "MATE keyboard configuration library")
    (description
     "Libmatekbd is a keyboard configuration library for the
MATE desktop environment.")
    (license license:lgpl2.1)))

(define-public mate-menus
  (package
    (name "mate-menus")
    (version "1.18.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pub.mate-desktop.org/releases/"
                                  (version-major+minor version) "/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "05kyr37xqv6hm1rlvnqd5ng0x1n883brqynkirkk5drl56axnz7h"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after
          'unpack 'fix-introspection-install-dir
          (lambda* (#:key outputs #:allow-other-keys)
            (let ((out (assoc-ref outputs "out")))
              (substitute* '("configure")
                (("`\\$PKG_CONFIG --variable=girdir gobject-introspection-1.0`")
                 (string-append "\"" out "/share/gir-1.0/\""))
                (("\\$\\(\\$PKG_CONFIG --variable=typelibdir gobject-introspection-1.0\\)")
                 (string-append out "/lib/girepository-1.0/")))
              #t))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("glib" ,glib)
       ("python" ,python-2)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Freedesktop menu specification implementation for MATE")
    (description
     "The package contains an implementation of the freedesktop menu
specification, the MATE menu layout configuration files, .directory files and
assorted menu related utility programs.")
    (license (list license:gpl2+ license:lgpl2.0+))))

(define-public mate-applets
  (package
    (name "mate-applets")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1nplr8i1mxbxd7pqhcy8j69v25nsp5dk9fq7ffrmjmp39lrf3fh5"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("libxslt" ,libxslt)
       ("yelp-tools" ,yelp-tools)
       ("scrollkeeper" ,scrollkeeper)
       ("gettext" ,gettext-minimal)
       ("docbook-xml" ,docbook-xml)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("atk" ,atk)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("glib" ,glib)
       ("gucharmap" ,gucharmap)
       ("gtk+" ,gtk+)
       ("gtksourceview" ,gtksourceview)
       ("libgtop" ,libgtop)
       ("libmateweather" ,libmateweather)
       ("libnotify" ,libnotify)
       ("libx11" ,libx11)
       ("libxml2" ,libxml2)
       ("libwnck" ,libwnck)
       ("mate-panel" ,mate-panel)
       ("pango" ,pango)
       ("polkit" ,polkit) ; either polkit or setuid
       ("python" ,python-2)
       ("upower" ,upower)
       ("wireless-tools" ,wireless-tools)))
    (propagated-inputs
     `(("python-pygobject" ,python-pygobject)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Various applets for the MATE Panel")
    (description
     "Mate-applets includes various small applications for Mate-panel:

@enumerate
@item accessx-status: indicates keyboard accessibility settings,
including the current state of the keyboard, if those features are in use.
@item Battstat: monitors the power subsystem on a laptop.
@item Character palette: provides a convenient way to access
non-standard characters, such as accented characters,
mathematical symbols, special symbols, and punctuation marks.
@item MATE CPUFreq Applet: CPU frequency scaling monitor
@item Drivemount: lets you mount and unmount drives and file systems.
@item Geyes: pair of eyes which follow the mouse pointer around the screen.
@item Keyboard layout switcher: lets you assign different keyboard
layouts for different locales.
@item Modem Monitor: monitors the modem.
@item Invest: downloads current stock quotes from the Internet and
displays the quotes in a scrolling display in the applet. The
applet downloads the stock information from Yahoo! Finance.
@item System monitor: CPU, memory, network, swap file and resource.
@item Trash: lets you drag items to the trash folder.
@item Weather report: downloads weather information from the
U.S National Weather Service (NWS) servers, including the
Interactive Weather Information Network (IWIN).
@end enumerate\n")
    (license (list license:gpl2+ license:lgpl2.0+ license:gpl3+))))

(define-public mate-media
  (package
    (name "mate-media")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1l0j71d07898wb6ily09sj1xczwrmcw13wyhxwns7sxw592nwi04"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gettext" ,gettext-minimal)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("cairo" ,cairo)
       ("gtk+" ,gtk+)
       ("libcanberra" ,libcanberra)
       ("libmatemixer" ,libmatemixer)
       ("libxml2" ,libxml2)
       ("mate-applets" ,mate-applets)
       ("mate-desktop" ,mate-desktop)
       ("mate-panel" ,mate-panel)
       ("pango" ,pango)
       ("startup-notification" ,startup-notification)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Multimedia related programs for the MATE desktop")
    (description
     "Mate-media includes the MATE media tools for MATE, including
mate-volume-control, a MATE volume control application and applet.")
    (license (list license:gpl2+ license:lgpl2.0+ license:fdl1.1+))))

(define-public mate-panel
  (package
    (name "mate-panel")
    (version "1.18.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1n565ff1n7jrfx223i3cl3m69wjda506nvbn8gra7m1jwdfzpbw1"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags
       (list (string-append "--with-zoneinfo-dir="
                            (assoc-ref %build-inputs "tzdata")
                            "/share/zoneinfo")
             "--with-in-process-applets=all")
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-timezone-path
           (lambda* (#:key inputs #:allow-other-keys)
             (let* ((tzdata (assoc-ref inputs "tzdata")))
               (substitute* "applets/clock/system-timezone.h"
                 (("/usr/share/lib/zoneinfo/tab")
                  (string-append tzdata "/share/zoneinfo/zone.tab"))
                 (("/usr/share/zoneinfo")
                  (string-append tzdata "/share/zoneinfo"))))
             #t))
         (add-after 'unpack 'fix-introspection-install-dir
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* '("configure")
                 (("`\\$PKG_CONFIG --variable=girdir gobject-introspection-1.0`")
                  (string-append "\"" out "/share/gir-1.0/\""))
                 (("\\$\\(\\$PKG_CONFIG --variable=typelibdir gobject-introspection-1.0\\)")
                  (string-append out "/lib/girepository-1.0/")))
               #t))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("itstool" ,itstool)
       ("xtrans" ,xtrans)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("dconf" ,dconf)
       ("cairo" ,cairo)
       ("dbus-glib" ,dbus-glib)
       ("gtk+" ,gtk+)
       ("libcanberra" ,libcanberra)
       ("libice" ,libice)
       ("libmateweather" ,libmateweather)
       ("librsvg" ,librsvg)
       ("libsm" ,libsm)
       ("libx11" ,libx11)
       ("libxau" ,libxau)
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libwnck" ,libwnck)
       ("mate-desktop" ,mate-desktop)
       ("mate-menus" ,mate-menus)
       ("pango" ,pango)
       ("tzdata" ,tzdata)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Panel for MATE")
    (description
     "Mate-panel contains the MATE panel, the libmate-panel-applet library and
several applets.  The applets supplied here include the Workspace Switcher,
the Window List, the Window Selector, the Notification Area, the Clock and the
infamous 'Wanda the Fish'.")
    (license (list license:gpl2+ license:lgpl2.0+))))

(define-public atril
  (package
    (name "atril")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1wl332v80c0nzz7nw36d1pfmbiibvl3l0i4d25ihg6mg9wbc0145"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list (string-append "--with-openjpeg="
                                              (assoc-ref %build-inputs "openjpeg"))
                               "--enable-introspection"
                               "--with-gtk=3.0"
                               "--disable-schemas-compile"
                               ;; FIXME: Enable build of Caja extensions.
                               "--disable-caja")
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-mathjax-path
           (lambda _
             (let* ((mathjax (assoc-ref %build-inputs "js-mathjax"))
                    (mathjax-path (string-append mathjax
                                                 "/share/javascript/mathjax")))
               (substitute* "backend/epub/epub-document.c"
                 (("/usr/share/javascript/mathjax")
                  mathjax-path)))
             #t))
         (add-after 'unpack 'fix-introspection-install-dir
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* '("configure")
                 (("\\$\\(\\$PKG_CONFIG --variable=girdir gobject-introspection-1.0\\)")
                  (string-append "\"" out "/share/gir-1.0/\""))
                 (("\\$\\(\\$PKG_CONFIG --variable=typelibdir gobject-introspection-1.0\\)")
                  (string-append out "/lib/girepository-1.0/")))
               #t)))
         (add-before 'install 'skip-gtk-update-icon-cache
           ;; Don't create 'icon-theme.cache'.
           (lambda _
             (substitute* "data/Makefile"
               (("gtk-update-icon-cache") "true"))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("itstool" ,itstool)
       ("yelp-tools" ,yelp-tools)
       ("glib:bin" ,glib "bin")
       ("gobject-introspection" ,gobject-introspection)
       ("gtk-doc" ,gtk-doc)
       ("xmllint" ,libxml2)
       ("zlib" ,zlib)))
    (inputs
     `(("atk" ,atk)
       ("cairo" ,cairo)
       ("caja" ,caja)
       ("dconf" ,dconf)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("djvulibre" ,djvulibre)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("ghostscript" ,ghostscript)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("js-mathjax" ,js-mathjax)
       ("libcanberra" ,libcanberra)
       ("libsecret" ,libsecret)
       ("libspectre" ,libspectre)
       ("libtiff" ,libtiff)
       ("libx11" ,libx11)
       ("libice" ,libice)
       ("libsm" ,libsm)
       ("libgxps" ,libgxps)
       ("libjpeg" ,libjpeg)
       ("libxml2" ,libxml2)
       ("dogtail" ,python2-dogtail)
       ("shared-mime-info" ,shared-mime-info)
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("gsettings-desktop-schemas" ,gsettings-desktop-schemas)
       ("libgnome-keyring" ,libgnome-keyring)
       ("libarchive" ,libarchive)
       ("marco" ,marco)
       ("nettle" ,nettle)
       ("openjpeg" ,openjpeg-1)
       ("pango" ,pango)
       ;;("texlive" ,texlive)
       ;; TODO:
       ;;   Build libkpathsea as a shared library for DVI support.
       ;; ("libkpathsea" ,texlive-bin)
       ("poppler" ,poppler)
       ("webkitgtk" ,webkitgtk)))
    (home-page "https://mate-desktop.org")
    (synopsis "Document viewer for Mate")
    (description
     "Document viewer for Mate")
    (license license:gpl2)))

(define-public caja
  (package
    (name "caja")
    (version "1.18.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0mljqcx7k8p27854zm7qzzn8ca6hs7hva9p43hp4p507z52caqmm"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags '("--disable-update-mimedb")
       #:tests? #f ; tests fail even with display set
       #:phases
       (modify-phases %standard-phases
         (add-before 'check 'pre-check
           (lambda _
             ;; Tests require a running X server.
             (system "Xvfb :1 &")
             (setenv "DISPLAY" ":1")
             ;; For the missing /etc/machine-id.
             (setenv "DBUS_FATAL_WARNINGS" "0")
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("glib:bin" ,glib "bin")
       ("xorg-server" ,xorg-server)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("exempi" ,exempi)
       ("gtk+" ,gtk+)
       ("gvfs" ,gvfs)
       ("libexif" ,libexif)
       ("libnotify" ,libnotify)
       ("libsm" ,libsm)
       ("libxml2" ,libxml2)
       ("mate-desktop" ,mate-desktop)
       ("startup-notification" ,startup-notification)))
    (native-search-paths
     (list (search-path-specification
            (variable "CAJA_EXTENSIONDIR")
            (files (list "lib/caja/extensions-2.0/**")))))
    (home-page "https://mate-desktop.org/")
    (synopsis "File manager for the MATE desktop")
    (description
     "Caja is the official file manager for the MATE desktop.
It allows for browsing directories, as well as previewing files and launching
applications associated with them.  Caja is also responsible for handling the
icons on the MATE desktop.  It works on local and remote file systems.")
    ;; There is a note about a TRADEMARKS_NOTICE file in COPYING which
    ;; does not exist. It is safe to assume that this is of no concern
    ;; for us.
    (license license:gpl2+)))

(define-public caja-extensions
  (package
    (name "caja-extensions")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0hgala7zkfsa60jflq3s4n9yd11dhfdcla40l83cmgc3r1az7cmw"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list "--enable-sendto"
                               ;; TODO: package "gupnp" to enable 'upnp', package
                               ;; "gksu" to enable 'gksu'.
                               (string-append "--with-sendto-plugins=removable-devices,"
                                              "caja-burn,emailclient,pidgin,gajim")
                               "--enable-image-converter"
                               "--enable-open-terminal" "--enable-share"
                               "--enable-wallpaper" "--enable-xattr-tags"
                               (string-append "--with-cajadir="
                                              (assoc-ref %outputs "out")
                                              "/lib/caja/extensions-2.0/"))))
    (native-inputs
     `(("intltool" ,intltool)
       ("gettext" ,gettext-minimal)
       ("glib:bin" ,glib "bin")
       ("gobject-introspection" ,gobject-introspection)
       ("gtk-doc" ,gtk-doc)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("attr" ,attr)
       ("brasero" ,brasero)
       ("caja" ,caja)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("gajim" ,gajim) ;runtime only?
       ("gtk+" ,gtk+)
       ("imagemagick" ,imagemagick)
       ("graphicsmagick" ,graphicsmagick)
       ("mate-desktop" ,mate-desktop)
       ("pidgin" ,pidgin) ;runtime only?
       ("startup-notification" ,startup-notification)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Extensions for the File manager Caja")
    (description
     "Caja is the official file manager for the MATE desktop.
It allows for browsing directories, as well as previewing files and launching
applications associated with them.  Caja is also responsible for handling the
icons on the MATE desktop.  It works on local and remote file systems.")
    (license license:gpl2+)))

(define-public mate-control-center
  (package
    (name "mate-control-center")
    (version "1.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0flnn0h8f5aqyccwrlv7qxchvr3kqmlfdga6wq28d55zkpv5m7dl"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("yelp-tools" ,yelp-tools)
       ("desktop-file-utils" ,desktop-file-utils)
       ("kbproto" ,kbproto)
       ("randrproto" ,randrproto)
       ("renderproto" ,renderproto)
       ("scrnsaverproto" ,scrnsaverproto)
       ("xextpro" ,xextproto)
       ("xproto" ,xproto)
       ("xmodmap" ,xmodmap)
       ("gobject-introspection" ,gobject-introspection)))
    (inputs
     `(("atk" ,atk)
       ("cairo" ,cairo)
       ("caja" ,caja)
       ("dconf" ,dconf)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("libcanberra" ,libcanberra)
       ("libmatekbd" ,libmatekbd)
       ("libx11" ,libx11)
       ("libxcursor" ,libxcursor)
       ("libxext" ,libxext)
       ("libxi" ,libxi)
       ("libxklavier" ,libxklavier)
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxscrnsaver" ,libxscrnsaver)
       ("marco" ,marco)
       ("mate-desktop" ,mate-desktop)
       ("mate-menus" ,mate-menus)
       ("mate-settings-daemon" ,mate-settings-daemon)
       ("pango" ,pango)
       ("startup-notification" ,startup-notification)))
    (propagated-inputs
     `(("gdk-pixbuf" ,gdk-pixbuf+svg) ; mate-slab.pc
       ("librsvg" ,librsvg))) ; mate-slab.pc
    (home-page "https://mate-desktop.org/")
    (synopsis "MATE Desktop configuration tool")
    (description
     "MATE control center is MATE's main interface for configuration
of various aspects of your desktop.")
    (license license:gpl2+)))

(define-public marco
  (package
    (name "marco")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0lwbp9wyd66hl5d7g272l8g3k1pb9s4s2p9fb04750a58w87d8k5"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("itstool" ,itstool)
       ("glib" ,glib)
       ("gobject-introspection" ,gobject-introspection)
       ("libxft" ,libxft)
       ("libxml2" ,libxml2)
       ("zenity" ,zenity)))
    (inputs
     `(("gtk+" ,gtk+)
       ("libcanberra" ,libcanberra)
       ("libgtop" ,libgtop)
       ("libice" ,libice)
       ("libsm" ,libsm)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxcursor" ,libxcursor)
       ("libxdamage" ,libxdamage)
       ("libxext" ,libxext)
       ("libxfixes" ,libxfixes)
       ("libxinerama" ,libxinerama)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("mate-desktop" ,mate-desktop)
       ("pango" ,pango)
       ("startup-notification" ,startup-notification)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Window manager for the MATE desktop")
    (description
     "Marco is a minimal X window manager that uses GTK+ for drawing
window frames.  It is aimed at non-technical users and is designed to integrate
well with the MATE desktop.  It lacks some features that may be expected by
some users; these users may want to investigate other available window managers
for use with MATE or as a standalone window manager.")
    (license license:gpl2+)))

(define-public mate-user-guide
  (package
    (name "mate-user-guide")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0f3b46r9a3cywm7rpj08xlkfnlfr9db58xfcpix8i33qp50fxqmb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'adjust-desktop-file
           (lambda* (#:key inputs #:allow-other-keys)
             (let* ((yelp (assoc-ref inputs "yelp")))
               (substitute* "mate-user-guide.desktop.in.in"
                 (("yelp")
                  (string-append yelp "/bin/yelp"))))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gettext" ,gettext-minimal)
       ("yelp-tools" ,yelp-tools)
       ("yelp-xsl" ,yelp-xsl)))
    (inputs
     `(("yelp" ,yelp)))
    (home-page "https://mate-desktop.org/")
    (synopsis "User Documentation for Mate software")
    (description
     "MATE User Guide is a collection of documentation which details
general use of the MATE Desktop environment.  Topics covered include
sessions, panels, menus, file management, and preferences.")
    (license (list license:fdl1.1+ license:gpl2+))))

(define-public mate-calc
  (package
    (name "mate-calc")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0qfs6kx2nymbn6j3mnzgvk8p54ghc78jslsf4wjqsdq021qyl0ly"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("atk" ,atk)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("libxml2" ,libxml2)
       ("libcanberra" ,libcanberra)
       ("pango" ,pango)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Calculator for MATE")
    (description
     "Mate Calc is the GTK+ calculator application for the MATE Desktop.")
    (license license:gpl2+)))

(define-public mate-backgrounds
  (package
    (name "mate-backgrounds")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "06q8ksjisijps2wn959arywsimhzd3j35mqkr048c26ck24d60zi"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("intltool" ,intltool)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Calculator for MATE")
    (description
     "This package contains a collection of graphics files which
can be used as backgrounds in the MATE Desktop environment.")
    (license license:gpl2+)))

(define-public mate-netbook
  (package
    (name "mate-netbook")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0zj4x9qis8dw0irxzb4va1189k8bqbvymxq3h7phnjwvr1m983gf"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("cairo" ,cairo)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("libfakekey" ,libfakekey)
       ("libwnck" ,libwnck)
       ("libxtst" ,libxtst)
       ("libx11" ,libx11)
       ("mate-panel" ,mate-panel)
       ("xproto" ,xproto)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Tool for MATE on Netbooks")
    (description
     "Mate Netbook is a simple window management tool which:

@enumerate
@item Allows you to set basic rules for a window type, such as maximise|undecorate
@item Allows exceptions to the rules, based on string matching for window name
and window class.
@item Allows 'reversing' of rules when the user manually changes something:
Re-decorates windows on un-maximise.
@end enumerate\n")
    (license license:gpl3+)))

(define-public mate-screensaver
  (package
    (name "mate-screensaver")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0dfi10faf1fnvrm7c7wnfqg35ygq09ws1vjyv8394jlf0nn39g9j"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags
       ;; FIXME: There is a permissions problem with screen locking
       ;; which effectively locks you out completely. Enable locking
       ;; once this has been fixed.
       (list "--enable-locking" "--with-kbd-layout-indicator"
             "--with-xf86gamma-ext" "--enable-pam"
             "--disable-schemas-compile" "--without-console-kit")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'autoconf
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (dbus-dir (string-append out "/share/dbus-1/services")))
             (setenv "SHELL" (which "sh"))
             (setenv "CONFIG_SHELL" (which "sh"))
             (substitute* "configure"
               (("dbus-1") ""))))))))
    (native-inputs
     `(("automake" ,automake)
       ("autoconf" ,autoconf-wrapper)
       ("gettext" ,gettext-minimal)
       ("intltool" ,intltool)
       ("kbproto" ,kbproto)
       ("mate-common" ,mate-common)
       ("pkg-config" ,pkg-config)
       ("randrproto" ,randrproto)
       ("renderproto" ,renderproto)
       ("scrnsaverproto" ,scrnsaverproto)
       ("which" ,which)
       ("xextpro" ,xextproto)
       ("xproto" ,xproto)))
    (inputs
     `(("cairo" ,cairo)
       ("dconf" ,dconf)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("gdk-pixbuf" ,gdk-pixbuf+svg)
       ("libcanberra" ,libcanberra)
       ("libglade" ,libglade)
       ("libmatekbd" ,libmatekbd)
       ("libnotify" ,libnotify)
       ("libx11" ,libx11)
       ("libxext" ,libxext)
       ("libxklavier" ,libxklavier)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxscrnsaver" ,libxscrnsaver)
       ("libxxf86vm" ,libxxf86vm)
       ("linux-pam" ,linux-pam)
       ("mate-desktop" ,mate-desktop)
       ("mate-menus" ,mate-menus)
       ("pango" ,pango)
       ("startup-notification" ,startup-notification)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Screensaver for MATE")
    (description
     "MATE backgrounds package contains a collection of graphics files which
can be used as backgrounds in the MATE Desktop environment.")
    (license license:gpl2+)))

(define-public mate-utils
  (package
    (name "mate-utils")
    (version "1.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0wr395dqfigj19ps0d76ycgwfljl9xxgs1a1g5wx6kcz5mvhzn5v"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("gtk-doc" ,gtk-doc)
       ("intltool" ,intltool)
       ("libice" ,libice)
       ("libsm" ,libsm)
       ("pkg-config" ,pkg-config)
       ("scrollkeeper" ,scrollkeeper)
       ("xextpro" ,xextproto)
       ("xproto" ,xproto)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("atk" ,atk)
       ("cairo" ,cairo)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("gdk-pixbuf" ,gdk-pixbuf+svg)
       ("libcanberra" ,libcanberra)
       ("libgtop" ,libgtop)
       ("libx11" ,libx11)
       ("libxext" ,libxext)
       ("mate-panel" ,mate-panel)
       ("pango" ,pango)
       ("zlib" ,zlib)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Utilities for the MATE Desktop")
    (description
     "Mate Utilities for the MATE Desktop containing:

@enumerate
@item mate-system-log
@item mate-search-tool
@item mate-dictionary
@item mate-screenshot
@item mate-disk-usage-analyzer
@end enumerate\n")
    (license (list license:gpl2
                   license:fdl1.1+
                   license:lgpl2.1))))

(define-public eom
  (package
    (name "eom")
    (version "1.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "00ns7g7qykakc89lijrw2vwy9x9ijqiyvmnd4sw0j6py90zs8m87"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("gtk-doc" ,gtk-doc)
       ("gobject-introspection" ,gobject-introspection)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("atk" ,atk)
       ("cairo" ,cairo)
       ("dconf" ,dconf)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("exempi" ,exempi)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("gdk-pixbuf" ,gdk-pixbuf+svg)
       ("libcanberra" ,libcanberra)
       ("libx11" ,libx11)
       ("libxext" ,libxext)
       ("libpeas" ,libpeas)
       ("libxml2" ,libxml2)
       ("libexif" ,libexif)
       ("libjpeg" ,libjpeg)
       ("librsvg" ,librsvg)
       ("lcms" ,lcms)
       ("mate-desktop" ,mate-desktop)
       ("pango" ,pango)
       ("shared-mime-info" ,shared-mime-info)
       ("startup-notification" ,startup-notification)
       ("zlib" ,zlib)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Eye of MATE")
    (description
     "Eye of MATE is the Image viewer for the MATE Desktop.")
    (license (list license:gpl2))))

(define-public engrampa
  (package
    (name "engrampa")
    (version "1.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "0d98zhqqc7qdnxcf0195kd04xmhijc0w2qrn6q61zd0daiswnv98"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:configure-flags (list "--disable-schemas-compile"
                               "--disable-run-in-place"
                               "--enable-magic"
                               "--enable-packagekit"
                               (string-append "--with-cajadir="
                                              (assoc-ref %outputs "out")
                                              "/lib/caja/extensions-2.0/"))
       #:phases
       (modify-phases %standard-phases
         (add-before 'install 'skip-gtk-update-icon-cache
           ;; Don't create 'icon-theme.cache'.
           (lambda _
             (substitute* "data/Makefile"
               (("gtk-update-icon-cache") "true"))
             #t)))))
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("gtk-doc" ,gtk-doc)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("caja" ,caja)
       ("file" ,file)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("gdk-pixbuf" ,gdk-pixbuf+svg)
       ("json-glib" ,json-glib)
       ("libcanberra" ,libcanberra)
       ("libx11" ,libx11)
       ("libsm" ,libsm)
       ("packagekit" ,packagekit)
       ("pango" ,pango)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Archive Manager for MATE")
    (description
     "Engrampa is the archive manager for the MATE Desktop.")
    (license license:gpl2)))

(define-public pluma
  (package
    (name "pluma")
    (version "1.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1z0938yiygxipj2a77n9dv8v4253snrc5gbbnarcnim9xba2j3zz"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(; Tests can not succeed.
       ;; https://github.com/mate-desktop/mate-text-editor/issues/33
       #:tests? #f))
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("gtk-doc" ,gtk-doc)
       ("gobject-introspection" ,gobject-introspection)
       ("intltool" ,intltool)
       ("libtool" ,libtool)
       ("pkg-config" ,pkg-config)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("atk" ,atk)
       ("cairo" ,cairo)
       ("enchant" ,enchant)
       ("glib" ,glib)
       ("gtk+" ,gtk+)
       ("gtksourceview" ,gtksourceview)
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("iso-codes" ,iso-codes)
       ("libcanberra" ,libcanberra)
       ("libx11" ,libx11)
       ("libsm" ,libsm)
       ("libpeas" ,libpeas)
       ("libxml2" ,libxml2)
       ("libice" ,libice)
       ("packagekit" ,packagekit)
       ("pango" ,pango)
       ("python-2" ,python-2)
       ("scrollkeeper" ,scrollkeeper)))
    (home-page "https://mate-desktop.org/")
    (synopsis "Text Editor for MATE")
    (description
     "Pluma is the text editor for the MATE Desktop.")
    (license license:gpl2)))

(define-public mate-system-monitor
  (package
    (name "mate-system-monitor")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1wcvrl4lfnjkhywb311p29prf1qiab6iynb6q1fgfsl6za8hsz48"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("gettext" ,gettext-minimal)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("yelp-tools" ,yelp-tools)))
    (inputs
     `(("cairo" ,cairo)
       ("glib" ,glib)
       ("glibmm" ,glibmm)
       ("gtkmm" ,gtkmm)
       ("gtk+" ,gtk+)
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("libsigc++" ,libsigc++)
       ("libcanberra" ,libcanberra)
       ("libxml2" ,libxml2)
       ("libwnck" ,libwnck)
       ("libgtop" ,libgtop)
       ("librsvg" ,librsvg)
       ("polkit" ,polkit)))
    (home-page "https://mate-desktop.org/")
    (synopsis "System Monitor for MATE")
    (description
     "Mate System Monitor provides a tool for for the
MATE Desktop to monitor your system resources and usage.")
    (license license:gpl2)))

(define-public mate-polkit
  (package
    (name "mate-polkit")
    (version "1.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pub.mate-desktop.org/releases/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "15vf2hnyjg8zsw3iiwjwi497yygkmvpnn6w1hik7dfw4a621w0gc"))))
    (build-system glib-or-gtk-build-system)
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("gtk-doc" ,gtk-doc)
       ("intltool" ,intltool)
       ("libtool" ,libtool)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("accountsservice" ,accountsservice)
       ("glib" ,glib)
       ("gobject-introspection" ,gobject-introspection)
       ("gtk+" ,gtk+)
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("polkit" ,polkit)))
    (home-page "https://mate-desktop.org/")
    (synopsis "DBus specific service for MATE")
    (description
     "MATE Polkit is a MATE specific DBUS service that is
used to bring up authentication dialogs.")
    (license license:lgpl2.1)))

(define-public mate
  (package
    (name "mate")
    (version (package-version mate-desktop))
    (source #f)
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build union))
       #:builder
       (begin
         (use-modules (ice-9 match)
                      (guix build union))
         (match %build-inputs
           (((names . directories) ...)
            (union-build (assoc-ref %outputs "out")
                         directories))))))
    (inputs
     ;; TODO: Add more packages
     `(("at-spi2-core"              ,at-spi2-core)
       ("atril"                     ,atril)
       ("caja"                      ,caja)
       ("dbus"                      ,dbus)
       ("dconf"                     ,dconf)
       ("desktop-file-utils"        ,desktop-file-utils)
       ("engrampa"                  ,engrampa)
       ("eom"                       ,eom)
       ("font-cantarell"            ,font-cantarell)
       ("glib-networking"           ,glib-networking)
       ("gnome-keyring"             ,gnome-keyring)
       ("gvfs"                      ,gvfs)
       ("hicolor-icon-theme"        ,hicolor-icon-theme)
       ("libmatekbd"                ,libmatekbd)
       ("libmateweather"            ,libmateweather)
       ("libmatemixer"              ,libmatemixer)
       ("marco"                     ,marco)
       ("mate-session-manager"      ,mate-session-manager)
       ("mate-settings-daemon"      ,mate-settings-daemon)
       ("mate-desktop"              ,mate-desktop)
       ("mate-terminal"             ,mate-terminal)
       ("mate-themes"               ,mate-themes)
       ("mate-icon-theme"           ,mate-icon-theme)
       ("mate-menu"                 ,mate-menus)
       ("mate-panel"                ,mate-panel)
       ("mate-control-center"       ,mate-control-center)
       ("mate-media"                ,mate-media)
       ("mate-applets"              ,mate-applets)
       ("mate-user-guide"           ,mate-user-guide)
       ("mate-calc"                 ,mate-calc)
       ("mate-backgrounds"          ,mate-backgrounds)
       ("mate-netbook"              ,mate-netbook)
       ("mate-utils"                ,mate-utils)
       ("mate-polkit"               ,mate-polkit)
       ("mate-system-monitor"       ,mate-system-monitor)
       ("mate-utils"                ,mate-utils)
       ("pluma"                     ,pluma)
       ("pinentry-gnome3"           ,pinentry-gnome3)
       ("pulseaudio"                ,pulseaudio)
       ("shared-mime-info"          ,shared-mime-info)
       ("yelp"                      ,yelp)
       ("zenity"                    ,zenity)))
    (synopsis "The MATE desktop environment")
    (home-page "https://mate-desktop.org/")
    (description
     "The MATE Desktop Environment is the continuation of GNOME 2.  It provides
an intuitive and attractive desktop environment using traditional metaphors for
GNU/Linux systems.  MATE is under active development to add support for new
technologies while preserving a traditional desktop experience.")
    (license license:gpl2+)))
