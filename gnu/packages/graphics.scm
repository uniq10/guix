;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015 Tomáš Čech <sleep_walker@gnu.org>
;;; Copyright © 2016 Leo Famulari <leo@famulari.name>
;;; Copyright © 2016, 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2017 Manolis Fragkiskos Ragkousis <manolis837@gmail.com>
;;; Copyright © 2017, 2018 Ben Woodcroft <donttrustben@gmail.com>
;;; Copyright © 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Mathieu Othacehe <m.othacehe@gmail.com>
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

(define-module (gnu packages graphics)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages python)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)  ;libsndfile, libsamplerate
  #:use-module (gnu packages compression)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages image)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages photo)
  #:use-module (gnu packages pth)
  #:use-module (gnu packages python)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages video)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg))

(define-public blender
  (package
    (name "blender")
    (version "2.79b")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://download.blender.org/source/"
                                  "blender-" version ".tar.gz"))
              (sha256
               (base32
                "1g4kcdqmf67srzhi3hkdnr4z1ph4h9sza1pahz38mrj998q4r52c"))))
    (build-system cmake-build-system)
    (arguments
      (let ((python-version (version-major+minor (package-version python))))
       `(;; Test files are very large and not included in the release tarball.
         #:tests? #f
         #:configure-flags
         (list "-DWITH_CODEC_FFMPEG=ON"
               "-DWITH_CODEC_SNDFILE=ON"
               "-DWITH_CYCLES=ON"
               "-DWITH_DOC_MANPAGE=ON"
               "-DWITH_FFTW3=ON"
               "-DWITH_GAMEENGINE=ON"
               "-DWITH_IMAGE_OPENJPEG=ON"
               "-DWITH_INPUT_NDOF=ON"
               "-DWITH_INSTALL_PORTABLE=OFF"
               "-DWITH_JACK=ON"
               "-DWITH_MOD_OCEANSIM=ON"
               "-DWITH_PLAYER=ON"
               "-DWITH_PYTHON_INSTALL=OFF"
               "-DWITH_PYTHON_INSTALL=OFF"
               "-DWITH_SYSTEM_OPENJPEG=ON"
               (string-append "-DPYTHON_LIBRARY=python" ,python-version "m")
               (string-append "-DPYTHON_LIBPATH=" (assoc-ref %build-inputs "python")
                              "/lib")
               (string-append "-DPYTHON_INCLUDE_DIR=" (assoc-ref %build-inputs "python")
                              "/include/python" ,python-version "m")
               (string-append "-DPYTHON_VERSION=" ,python-version))
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-broken-import
             (lambda _
               (substitute* "release/scripts/addons/io_scene_fbx/json2fbx.py"
                 (("import encode_bin") "from . import encode_bin"))
               #t))
           (add-after 'set-paths 'add-ilmbase-include-path
             (lambda* (#:key inputs #:allow-other-keys)
               ;; OpenEXR propagates ilmbase, but its include files do not appear
               ;; in the CPATH, so we need to add "$ilmbase/include/OpenEXR/" to
               ;; the CPATH to satisfy the dependency on "half.h".
               (setenv "CPATH"
                       (string-append (assoc-ref inputs "ilmbase")
                                      "/include/OpenEXR"
                                      ":" (or (getenv "CPATH") "")))
               #t))))))
    (inputs
     `(("boost" ,boost)
       ("jemalloc" ,jemalloc)
       ("libx11" ,libx11)
       ("openimageio" ,openimageio)
       ("openexr" ,openexr)
       ("ilmbase" ,ilmbase)
       ("openjpeg" ,openjpeg-1)
       ("libjpeg" ,libjpeg)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("ffmpeg-2.8" ,ffmpeg-2.8) ;<https://lists.gnu.org/archive/html/guix-devel/2016-04/msg01019.html>
       ("fftw" ,fftw)
       ("jack" ,jack-1)
       ("libsndfile" ,libsndfile)
       ("freetype" ,freetype)
       ("glew" ,glew)
       ("openal" ,openal)
       ("python" ,python)
       ("zlib" ,zlib)))
    (home-page "https://blender.org/")
    (synopsis "3D graphics creation suite")
    (description
     "Blender is a 3D graphics creation suite.  It supports the entirety of
the 3D pipeline—modeling, rigging, animation, simulation, rendering,
compositing and motion tracking, even video editing and game creation.  The
application can be customized via its API for Python scripting.")
    (license license:gpl2+)))

(define-public assimp
  (package
    (name "assimp")
    (version "3.3.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/assimp/assimp/archive/v"
                                  version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1gy7zlgkf4nmyv8n674p3f30asis0gjz8icyy11i693n13ww71fk"))))
    (build-system cmake-build-system)
    (inputs
     `(("zlib" ,zlib)))
    (home-page "http://assimp.org/")
    (synopsis "Asset import library")
    (description
     "The Open Asset Import Library loads more than 40 3D file formats into
one unified data structure.  Additionally, assimp features various mesh post
processing tools: normals and tangent space generation, triangulation, vertex
cache locality optimization, removal of degenerate primitives and duplicate
vertices, sorting by primitive type, merging of redundant materials and many
more.")
    (license license:bsd-3)))

(define-public cgal
  (package
    (name "cgal")
    (version "4.8.1")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/CGAL/cgal/releases/download/releases/"
                    "CGAL-" version "/CGAL-" version ".tar.xz"))
              (sha256
               (base32
                "1c41yzl2jg3d6zx5k0iccwqwibp950q7dr7z7pp4xi9wlph3c87s"))))
    (build-system cmake-build-system)
    (arguments
     '(;; "RelWithDebInfo" is not supported.
       #:build-type "Release"

       ;; No 'test' target.
       #:tests? #f))
    (inputs
     `(("mpfr" ,mpfr)
       ("gmp" ,gmp)
       ("boost" ,boost)))
    (home-page "http://cgal.org/")
    (synopsis "Computational geometry algorithms library")
    (description
     "CGAL provides easy access to efficient and reliable geometric algorithms
in the form of a C++ library.  CGAL is used in various areas needing geometric
computation, such as: computer graphics, scientific visualization, computer
aided design and modeling, geographic information systems, molecular biology,
medical imaging, robotics and motion planning, mesh generation, numerical
methods, etc.  It provides data structures and algorithms such as
triangulations, Voronoi diagrams, polygons, polyhedra, mesh generation, and
many more.")

    ;; The 'LICENSE' file explains that a subset is available under more
    ;; permissive licenses.
    (license license:gpl3+)))

(define-public ilmbase
  (package
    (name "ilmbase")
    (version "2.2.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://savannah/openexr/ilmbase-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "17k0hq19wplx9s029kjrq6c51x2ryrfmaavcappkd0g67gk0dhna"))
              (patches (search-patches "ilmbase-fix-tests.patch"))))
    (build-system gnu-build-system)
    (home-page "http://www.openexr.com/")
    (synopsis "Utility C++ libraries for threads, maths, and exceptions")
    (description
     "IlmBase provides several utility libraries for C++.  Half is a class
that encapsulates ILM's 16-bit floating-point format.  IlmThread is a thread
abstraction.  Imath implements 2D and 3D vectors, 3x3 and 4x4 matrices,
quaternions and other useful 2D and 3D math functions.  Iex is an
exception-handling library.")
    (license license:bsd-3)))

(define-public ogre
  (package
    (name "ogre")
    (version "1.10.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/OGRECave/" name
                           "/archive/v" version ".tar.gz"))
       (sha256
        (base32
         "13bdh9v4026qf8w8rbfln2rmwf0rby1a8fz55zpdvpy105i6cbpz"))
       (file-name (string-append name "-" version ".tar.gz"))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'pre-configure
           (lambda _
             ;; It expects googletest source to be downloaded and
             ;; be in a specific place.
             (substitute* "Tests/CMakeLists.txt"
               (("URL(.*)$" _ suffix)
                (string-append "URL " suffix
                               "\t\tURL_HASH "
                               "MD5=16877098823401d1bf2ed7891d7dce36\n")))
             #t))
         (add-before 'build 'pre-build
           (lambda* (#:key inputs #:allow-other-keys)
             (copy-file (assoc-ref inputs "googletest-source")
                        (string-append (getcwd)
                                       "/Tests/googletest-prefix/src/"
                                       "release-1.8.0.tar.gz"))
             #t)))
       #:configure-flags
       (list "-DOGRE_BUILD_TESTS=TRUE"
             (string-append "-DCMAKE_INSTALL_RPATH="
                            (assoc-ref %outputs "out") "/lib:"
                            (assoc-ref %outputs "out") "/lib/OGRE:"
                            (assoc-ref %build-inputs "googletest") "/lib")
             "-DOGRE_INSTALL_DOCS=TRUE"
             "-DOGRE_INSTALL_SAMPLES=TRUE"
             "-DOGRE_INSTALL_SAMPLES_SOURCE=TRUE")))
    (native-inputs
     `(("boost" ,boost)
       ("doxygen" ,doxygen)
       ("googletest-source" ,(package-source googletest))
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("font-dejavu" ,font-dejavu)
       ("freeimage" ,freeimage)
       ("freetype" ,freetype)
       ("glu" ,glu)
       ("googletest" ,googletest)
       ("sdl2" ,sdl2)
       ("libxaw" ,libxaw)
       ("libxrandr" ,libxrandr)
       ("tinyxml" ,tinyxml)
       ("zziplib" ,zziplib)))
    (synopsis "Scene-oriented, flexible 3D engine written in C++")
    (description
     "OGRE (Object-Oriented Graphics Rendering Engine) is a scene-oriented,
flexible 3D engine written in C++ designed to make it easier and more intuitive
for developers to produce applications utilising hardware-accelerated 3D
graphics.")
    (home-page "http://www.ogre3d.org/")
    (license license:expat)))

(define-public openexr
  (package
    (name "openexr")
    (version "2.2.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://savannah/openexr/openexr-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1kdf2gqznsdinbd5vcmqnif442nyhdf9l7ckc51410qm2gv5m6lg"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (substitute* (find-files "." "tmpDir\\.h")
                    (("\"/var/tmp/\"")
                     "\"/tmp/\""))

                  ;; Install 'ImfStdIO.h'.  Reported at
                  ;; <https://lists.nongnu.org/archive/html/openexr-devel/2016-06/msg00001.html>
                  ;; and <https://github.com/openexr/openexr/pull/184>.
                  (substitute* "IlmImf/Makefile.in"
                    (("ImfIO\\.h")
                     "ImfIO.h ImfStdIO.h"))))
              (patches (search-patches "openexr-missing-samples.patch"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-broken-test
           ;; This test fails on i686. Upstream developers suggest that
           ;; this test is broken on i686 and can be safely disabled:
           ;; https://github.com/openexr/openexr/issues/67#issuecomment-21169748
           (lambda _
             (substitute* "IlmImfTest/main.cpp"
               (("#include \"testOptimizedInterleavePatterns.h\"")
                 "//#include \"testOptimizedInterleavePatterns.h\"")
               (("TEST \\(testOptimizedInterleavePatterns")
                 "//TEST (testOptimizedInterleavePatterns"))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (propagated-inputs
     `(("ilmbase" ,ilmbase)                       ;used in public headers
       ("zlib" ,zlib)))                           ;OpenEXR.pc reads "-lz"
    (home-page "http://www.openexr.com")
    (synopsis "High-dynamic range file format library")
    (description
     "OpenEXR is a high dynamic-range (HDR) image file format developed for
use in computer imaging applications.  The IlmImf C++ libraries support
storage of the \"EXR\" file format for storing 16-bit floating-point images.")
    (license license:bsd-3)))

(define-public openimageio
  (package
    (name "openimageio")
    (version "1.6.15")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/OpenImageIO/oiio/"
                                  "archive/Release-" version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "144crq0205d0w5aq4iglh2rhzf54a8rv3pksy6d533b75w5d7rq7"))))
    (build-system cmake-build-system)
    ;; FIXME: To run all tests successfully, test image sets from multiple
    ;; third party sources have to be present.  For details see
    ;; https://github.com/OpenImageIO/oiio/blob/master/INSTALL
    (arguments `(#:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("libpng" ,libpng)
       ("libjpeg" ,libjpeg-8)
       ("libtiff" ,libtiff)
       ("giflib" ,giflib)
       ("openexr" ,openexr)
       ("ilmbase" ,ilmbase)
       ("python" ,python-2)
       ("zlib" ,zlib)))
    (synopsis "C++ library for reading and writing images")
    (description
     "OpenImageIO is a library for reading and writing images, and a bunch of
related classes, utilities, and applications.  There is a particular emphasis
on formats and functionality used in professional, large-scale animation and
visual effects work for film.")
    (home-page "http://www.openimageio.org")
    (license license:bsd-3)))

(define-public openscenegraph
  (package
    (name "openscenegraph")
    (version "3.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://trac.openscenegraph.org/downloads/developer_releases/"
                           "OpenSceneGraph-" version ".zip"))
       (sha256
        (base32
         "03h4wfqqk7rf3mpz0sa99gy715cwpala7964z2npd8jxfn27swjw"))
       (patches (search-patches "openscenegraph-ffmpeg3.patch"))
       (file-name (string-append name "-" version ".zip"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f ; no test target available
       ;; Without this flag, 'rd' will be added to the name of the
       ;; library binaries and break linking with other programs.
       #:build-type "Release"
       #:configure-flags
       (list (string-append "-DCMAKE_INSTALL_RPATH="
                            (assoc-ref %outputs "out") "/lib:"
                            (assoc-ref %outputs "out") "/lib64"))))
    (native-inputs
     `(("unzip" ,unzip)))
    (inputs
     `(("giflib" ,giflib)
       ("jasper" ,jasper)
       ("librsvg" ,librsvg)
       ("pth" ,pth)
       ("qtbase" ,qtbase)
       ("ffmpeg" ,ffmpeg)
       ("mesa" ,mesa)))
    (synopsis "High performance real-time graphics toolkit")
    (description
     "The OpenSceneGraph is a high performance 3D graphics toolkit
used by application developers in fields such as visual simulation, games,
virtual reality, scientific visualization and modeling.")
    (home-page "http://www.openscenegraph.org")
    ;; The 'LICENSE' file explains that the source is licensed under
    ;; LGPL 2.1, but with 4 exceptions. This version is called OSGPL.
    (license license:lgpl2.1)))

(define-public rapicorn
  (package
    (name "rapicorn")
    (version "16.0.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://testbit.eu/pub/dists/rapicorn/"
                                  "rapicorn-" version ".tar.xz"))
              (sha256
               (base32
                "1y51yjrpsihas1jy905m9p3r8iiyhq6bwi2690c564i5dnix1f9d"))
              (patches (search-patches "rapicorn-isnan.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-tests
           (lambda _
             ;; Our grep does not support perl regular expressions.
             (substitute* "taptool.sh"
               (("grep -P") "grep -E"))
             ;; Disable path tests because we cannot access /bin or /sbin.
             (substitute* "rcore/tests/multitest.cc"
               (("TCMP \\(Path::equals \\(\"/bin\"") "//"))
             #t))
         (add-before 'check 'pre-check
           (lambda _
             ;; The test suite requires a running X server (with DISPLAY
             ;; number 99 or higher).
             (system "Xvfb :99 &")
             (setenv "DISPLAY" ":99")
             #t))
         (add-after 'unpack 'replace-fhs-paths
           (lambda _
             (substitute* (cons "Makefile.decl"
                                (find-files "." "^Makefile\\.in$"))
               (("/bin/ls") (which "ls"))
               (("/usr/bin/env") (which "env")))
             #t)))))
    ;; These libraries are listed in the "Required" section of the pkg-config
    ;; file.
    (propagated-inputs
     `(("librsvg" ,librsvg)
       ("cairo" ,cairo)
       ("pango" ,pango)
       ("libxml2" ,libxml2)
       ("python2-enum34" ,python2-enum34)))
    (inputs
     `(("gdk-pixbuf" ,gdk-pixbuf)
       ("libpng" ,libpng-1.2)
       ("readline" ,readline)
       ("libcroco" ,libcroco)
       ("python" ,python-2)
       ("cython" ,python2-cython)))
    (native-inputs
     `(("pandoc" ,ghc-pandoc)
       ("bison" ,bison)
       ("flex" ,flex)
       ("doxygen" ,doxygen)
       ("graphviz" ,graphviz)
       ("intltool" ,intltool)
       ("pkg-config" ,pkg-config)
       ("xvfb" ,xorg-server)))
    (home-page "https://rapicorn.testbit.org/")
    (synopsis "Toolkit for rapid development of user interfaces")
    (description
     "Rapicorn is a toolkit for rapid development of user interfaces in C++
and Python.  The user interface is designed in a declarative markup language
and is connected to the programming logic using data bindings and commands.")
    (license license:mpl2.0)))

(define-public ctl
  (package
    (name "ctl")
    (version "1.5.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/ampas/CTL/archive/ctl-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1gg04pyvw0m398akn0s1l07g5b1haqv5na1wpi5dii1jjd1w3ynp"))))
    (build-system cmake-build-system)
    (arguments '(#:tests? #f))                    ;no 'test' target

    ;; Headers include OpenEXR and IlmBase headers.
    (propagated-inputs `(("openexr" ,openexr)))

    (home-page "http://ampasctl.sourceforge.net")
    (synopsis "Color Transformation Language")
    (description
     "The Color Transformation Language, or CTL, is a small programming
language that was designed to serve as a building block for digital color
management systems.  CTL allows users to describe color transforms in a
concise and unambiguous way by expressing them as programs.  In order to apply
a given transform to an image, the color management system instructs a CTL
interpreter to load and run the CTL program that describes the transform.  The
original and the transformed image constitute the CTL program's input and
output.")

    ;; The web site says it's under a BSD-3 license, but the 'LICENSE' file
    ;; and headers use different wording.
    (license (license:non-copyleft "file://LICENSE"))))

(define-public brdf-explorer
  ;; There are no release tarballs, and not even tags in the repo,
  ;; so use the latest revision.
  (let ((commit "5b2cd46f38a06e47207fa7229b72d37beb945019")
        (revision "1"))
    (package
      (name "brdf-explorer")
      (version (string-append "1.0.0-" revision "." (string-take commit 9)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/wdas/brdf.git")
                      (commit commit)))
                (sha256
                 (base32
                  "06vzbiajzbi2xl8jlff5d45bc9wd68i3jdndfab1f3jgfrd8bsgx"))
                (file-name (string-append name "-" version "-checkout"))))
      (build-system gnu-build-system)
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (replace 'configure
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let ((out (assoc-ref outputs "out")))
                          (zero? (system* "qmake"
                                          (string-append "prefix=" out))))))
                    (add-after 'install 'wrap-program
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let* ((out (assoc-ref outputs "out"))
                               (bin (string-append out "/bin"))
                               (data (string-append
                                      out "/share/brdf")))
                          (with-directory-excursion bin
                            (rename-file "brdf" ".brdf-real")
                            (call-with-output-file "brdf"
                              (lambda (port)
                                (format port "#!/bin/sh
# Run the thing from its home, otherwise it just bails out.
cd \"~a\"
exec -a \"$0\" ~a/.brdf-real~%"
                                        data bin)))
                            (chmod "brdf" #o555))))))))
      (native-inputs
       `(("qttools" ,qttools))) ;for 'qmake'
      (inputs
       `(("qtbase" ,qtbase)
         ("mesa" ,mesa)
         ("glew" ,glew)
         ("freeglut" ,freeglut)
         ("zlib" ,zlib)))
      (home-page "http://www.disneyanimation.com/technology/brdf.html")
      (synopsis
       "Analyze bidirectional reflectance distribution functions (BRDFs)")
      (description
       "BRDF Explorer is an application that allows the development and analysis
of bidirectional reflectance distribution functions (BRDFs).  It can load and
plot analytic BRDF functions (coded as functions in OpenGL's GLSL shader
language), measured material data from the MERL database, and anisotropic
measured material data from MIT CSAIL.  Graphs and visualizations update in
real time as parameters are changed, making it a useful tool for evaluating
and understanding different BRDFs (and other component functions).")
      (license license:ms-pl))))

(define-public agg
  (package
    (name "agg")
    (version "2.5")
    (source (origin
              (method url-fetch)
              (uri (list (string-append
                          "ftp://ftp.fau.de/gentoo/distfiles/agg-"
                          version ".tar.gz")
                         (string-append
                          "ftp://ftp.ula.ve/gentoo/distfiles/agg-"
                          version ".tar.gz")

                         ;; Site was discontinued.
                         (string-append "http://www.antigrain.com/agg-"
                                        version ".tar.gz")))
              (sha256
               (base32 "07wii4i824vy9qsvjsgqxppgqmfdxq0xa87i5yk53fijriadq7mb"))
              (patches (search-patches "agg-am_c_prototype.patch"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       (list (string-append "--x-includes=" (assoc-ref %build-inputs "libx11")
                            "/include")
             (string-append "--x-libraries=" (assoc-ref %build-inputs "libx11")
                            "/lib"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'autoreconf
           (lambda _
             ;; let's call configure from configure phase and not now
             (substitute* "autogen.sh" (("./configure") "# ./configure"))
             (zero? (system* "sh" "autogen.sh")))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("libtool" ,libtool)
       ("autoconf" ,autoconf)
       ("automake" ,automake)
       ("bash" ,bash)))
    (inputs
     `(("libx11" ,libx11)
       ("freetype" ,freetype)
       ("sdl" ,sdl)))

    ;; Antigrain.com was discontinued.
    (home-page "http://agg.sourceforge.net/antigrain.com/index.html")
    (synopsis "High-quality 2D graphics rendering engine for C++")
    (description
     "Anti-Grain Geometry is a high quality rendering engine written in C++.
It supports sub-pixel resolutions and anti-aliasing.  It is also library for
rendering SVG graphics.")
    (license license:gpl2+)))

(define-public python-pastel
  (package
    (name "python-pastel")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pastel" version))
       (sha256
        (base32
         "1hqbm934n5yjwn31aq8h7shrr0rcy326wrqfc856vyn0gr0sy21i"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "https://github.com/sdispater/pastel")
    (synopsis "Library to colorize strings in your terminal")
    (description "Pastel is a simple library to help you colorize strings in
your terminal.  It comes bundled with predefined styles:
@enumerate
@item info: green
@item comment: yellow
@item question: black on cyan
@item error: white on red
@end enumerate
")
    (license license:expat)))

(define-public python2-pastel
  (package-with-python2 python-pastel))

(define-public fgallery
  (package
    (name "fgallery")
    (version "1.8.2")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "http://www.thregr.org/~wavexx/software/fgallery/releases/"
                "fgallery-" version ".zip"))
              (sha256
               (base32
                "18wlvqbxcng8pawimbc8f2422s8fnk840hfr6946lzsxr0ijakvf"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out    (assoc-ref outputs "out"))
                    (bin    (string-append out "/bin/"))
                    (share  (string-append out "/share/fgallery"))
                    (man    (string-append out "/share/man/man1"))
                    (perl5lib (getenv "PERL5LIB"))
                    (script (string-append share "/fgallery")))
               (define (bin-directory input-name)
                 (string-append (assoc-ref inputs input-name) "/bin"))

               (mkdir-p man)
               (copy-file "fgallery.1" (string-append man "/fgallery.1"))

               (mkdir-p share)
               (copy-recursively "." share)

               ;; fgallery copies files from store when it is run. The
               ;; read-only permissions from the store directories will cause
               ;; fgallery to fail. Do not preserve file attributes when
               ;; copying files to prevent it.
               (substitute* script
                 (("'cp'")
                  "'cp', '--no-preserve=all'"))

               (mkdir-p bin)
               (symlink script (string-append out "/bin/fgallery"))

               (wrap-program script
                 `("PATH" ":" prefix
                   ,(map bin-directory '("imagemagick"
                                         "lcms"
                                         "fbida"
                                         "libjpeg"
                                         "zip"
                                         "jpegoptim"
                                         "pngcrush"
                                         "p7zip")))
                 `("PERL5LIB" ":" prefix (,perl5lib)))
               #t))))))
    (native-inputs
     `(("unzip" ,unzip)))
    ;; TODO: Add missing optional dependency: facedetect.
    (inputs
     `(("imagemagick" ,imagemagick)
       ("lcms" ,lcms)
       ("fbida" ,fbida)
       ("libjpeg" ,libjpeg)
       ("zip" ,zip)
       ("perl" ,perl)
       ("perl-cpanel-json-xs" ,perl-cpanel-json-xs)
       ("perl-image-exiftool" ,perl-image-exiftool)
       ("jpegoptim" ,jpegoptim)
       ("pngcrush" ,pngcrush)
       ("p7zip" ,p7zip)))
    (home-page "http://www.thregr.org/~wavexx/software/fgallery/")
    (synopsis "Static photo gallery generator")
    (description
     "FGallery is a static, JavaScript photo gallery generator with minimalist
look.  The result can be uploaded on any web server without additional
requirements.")
    (license license:gpl2+)))
