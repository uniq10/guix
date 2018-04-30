;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016, 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2016 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Mark Meyer <mark@ofosos.org>
;;; Copyright © 2018 Ben Woodcroft <donttrustben@gmail.com>
;;; Copyright © 2018 Fis Trivial <ybbs.daans@hotmail.com>
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

(define-module (gnu packages machine-learning)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix svn-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system ocaml)
  #:use-module (guix build-system python)
  #:use-module (guix build-system r)
  #:use-module (guix git-download)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cran)
  #:use-module (gnu packages dejagnu)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages image)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg))

(define-public fann
  ;; The last release is >100 commits behind, so we package from git.
  (let ((commit "d71d54788bee56ba4cf7522801270152da5209d7"))
    (package
      (name "fann")
      (version (string-append "2.2.0-1." (string-take commit 8)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/libfann/fann.git")
                      (commit commit)))
                (file-name (string-append name "-" version "-checkout"))
                (sha256
                 (base32
                  "0ibwpfrjs6q2lijs8slxjgzb2llcl6rk3v2ski4r6215g5jjhg3x"))))
      (build-system cmake-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (replace 'check
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out")))
                 (with-directory-excursion (string-append (getcwd) "/tests")
                   (invoke "./fann_tests"))))))))
      (home-page "http://leenissen.dk/fann/wp/")
      (synopsis "Fast Artificial Neural Network")
      (description
       "FANN is a free open source neural network library, which implements
multilayer artificial neural networks in C with support for both fully
connected and sparsely connected networks.")
      (license license:lgpl2.1))))

(define-public libsvm
  (package
    (name "libsvm")
    (version "3.22")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
                           name "-" version ".tar.gz"))
       (sha256
        (base32
         "0zd7s19y5vb7agczl6456bn45cj1y64739sslaskw1qk7dywd0bd"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ;no "check" target
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (replace
                   'install             ; no ‘install’ target
                   (lambda* (#:key outputs #:allow-other-keys)
                     (let* ((out (assoc-ref outputs "out"))
                            (bin (string-append out "/bin/")))
                       (mkdir-p bin)
                       (for-each (lambda (file)
                                   (copy-file file (string-append bin file)))
                                 '("svm-train"
                                   "svm-predict"
                                   "svm-scale")))
                     #t)))))
    (home-page "http://www.csie.ntu.edu.tw/~cjlin/libsvm/")
    (synopsis "Library for Support Vector Machines")
    (description
     "LIBSVM is a machine learning library for support vector
classification, (C-SVC, nu-SVC), regression (epsilon-SVR, nu-SVR) and
distribution estimation (one-class SVM).  It supports multi-class
classification.")
    (license license:bsd-3)))

(define-public python-libsvm
  (package (inherit libsvm)
    (name "python-libsvm")
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ;no "check" target
       #:make-flags '("-C" "python")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace
          'install                      ; no ‘install’ target
          (lambda* (#:key inputs outputs #:allow-other-keys)
            (let ((site (string-append (assoc-ref outputs "out")
                                       "/lib/python"
                                       (string-take
                                        (string-take-right
                                         (assoc-ref inputs "python") 5) 3)
                                       "/site-packages/")))
              (substitute* "python/svm.py"
                (("../libsvm.so.2") "libsvm.so.2"))
              (mkdir-p site)
              (for-each (lambda (file)
                          (copy-file file (string-append site (basename file))))
                        (find-files "python" "\\.py"))
              (copy-file "libsvm.so.2"
                         (string-append site "libsvm.so.2")))
            #t)))))
    (inputs
     `(("python" ,python)))
    (synopsis "Python bindings of libSVM")))

(define-public ghmm
  ;; The latest release candidate is several years and a couple of fixes have
  ;; been published since.  This is why we download the sources from the SVN
  ;; repository.
  (let ((svn-revision 2341))
    (package
      (name "ghmm")
      (version (string-append "0.9-rc3-0." (number->string svn-revision)))
      (source (origin
                (method svn-fetch)
                (uri (svn-reference
                      (url "http://svn.code.sf.net/p/ghmm/code/trunk")
                      (revision svn-revision)))
                (file-name (string-append name "-" version))
                (sha256
                 (base32
                  "0qbq1rqp94l530f043qzp8aw5lj7dng9wq0miffd7spd1ff638wq"))))
      (build-system gnu-build-system)
      (arguments
       `(#:imported-modules (,@%gnu-build-system-modules
                             (guix build python-build-system))
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'enter-dir
             (lambda _ (chdir "ghmm") #t))
           (delete 'check)
           (add-after 'install 'check
             (assoc-ref %standard-phases 'check))
           (add-before 'check 'fix-PYTHONPATH
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((python-version ((@@ (guix build python-build-system)
                                           get-python-version)
                                      (assoc-ref inputs "python"))))
                 (setenv "PYTHONPATH"
                         (string-append (getenv "PYTHONPATH")
                                        ":" (assoc-ref outputs "out")
                                        "/lib/python" python-version
                                        "/site-packages")))
               #t))
           (add-after 'enter-dir 'fix-runpath
             (lambda* (#:key outputs #:allow-other-keys)
               (substitute* "ghmmwrapper/setup.py"
                 (("^(.*)extra_compile_args = \\[" line indent)
                  (string-append indent
                                 "extra_link_args = [\"-Wl,-rpath="
                                 (assoc-ref outputs "out") "/lib\"],\n"
                                 line
                                 "\"-Wl,-rpath="
                                 (assoc-ref outputs "out")
                                 "/lib\", ")))
               #t))
           (add-after 'enter-dir 'disable-broken-tests
             (lambda _
               (substitute* "tests/Makefile.am"
                 ;; GHMM_SILENT_TESTS is assumed to be a command.
                 (("TESTS_ENVIRONMENT.*") "")
                 ;; Do not build broken tests.
                 (("chmm .*") "")
                 (("read_fa .*") "")
                 (("mcmc .*") "")
                 (("label_higher_order_test.*$")
                  "label_higher_order_test\n"))

               ;; These Python unittests are broken as there is no gato.
               ;; See https://sourceforge.net/p/ghmm/support-requests/3/
               (substitute* "ghmmwrapper/ghmmunittests.py"
                 (("^(.*)def (testNewXML|testMultipleTransitionClasses|testNewXML)"
                   line indent)
                  (string-append indent
                                 "@unittest.skip(\"Disabled by Guix\")\n"
                                 line)))
               #t))
           (add-after 'disable-broken-tests 'autogen
             (lambda _
               (zero? (system* "bash" "autogen.sh")))))))
      (inputs
       `(("python" ,python-2) ; only Python 2 is supported
         ("libxml2" ,libxml2)))
      (native-inputs
       `(("pkg-config" ,pkg-config)
         ("dejagnu" ,dejagnu)
         ("swig" ,swig)
         ("autoconf" ,autoconf)
         ("automake" ,automake)
         ("libtool" ,libtool)))
      (home-page "http://ghmm.org")
      (synopsis "Hidden Markov Model library")
      (description
       "The General Hidden Markov Model library (GHMM) is a C library with
additional Python bindings implementing a wide range of types of @dfn{Hidden
Markov Models} (HMM) and algorithms: discrete, continuous emissions, basic
training, HMM clustering, HMM mixtures.")
      (license license:lgpl2.0+))))

(define-public mcl
  (package
    (name "mcl")
    (version "14.137")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://micans.org/mcl/src/mcl-"
                    (string-replace-substring version "." "-")
                    ".tar.gz"))
              (sha256
               (base32
                "15xlax3z31lsn62vlg94hkm75nm40q4679amnfg13jm8m2bnhy5m"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags (list "--enable-blast")))
    (inputs
     `(("perl" ,perl)))
    (home-page "http://micans.org/mcl/")
    (synopsis "Clustering algorithm for graphs")
    (description
     "The MCL algorithm is short for the @dfn{Markov Cluster Algorithm}, a
fast and scalable unsupervised cluster algorithm for graphs (also known as
networks) based on simulation of (stochastic) flow in graphs.")
    ;; In the LICENCE file and web page it says "The software is licensed
    ;; under the GNU General Public License, version 3.", but in several of
    ;; the source code files it suggests GPL3 or later.
    ;; http://listserver.ebi.ac.uk/pipermail/mcl-users/2016/000376.html
    (license license:gpl3)))

(define-public ocaml-mcl
  (package
    (name "ocaml-mcl")
    (version "12-068oasis4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/fhcrc/mcl/archive/"
             version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1l5jbhwjpsj38x8b9698hfpkv75h8hn3kj0gihjhn8ym2cwwv110"))))
    (build-system ocaml-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'patch-paths
           (lambda _
             (substitute* "configure"
               (("SHELL = /bin/sh") (string-append "SHELL = "(which "sh"))))
             (substitute* "setup.ml"
               (("LDFLAGS=-fPIC")
                (string-append "LDFLAGS=-fPIC\"; \"SHELL=" (which "sh"))))
             #t)))))
    (home-page "https://github.com/fhcrc/mcl")
    (synopsis "OCaml wrappers around MCL")
    (description
     "This package provides OCaml bindings for the MCL graph clustering
algorithm.")
    (license license:gpl3)))

(define-public ocaml4.01-mcl
  (package-with-ocaml4.01 ocaml-mcl))

(define-public randomjungle
  (package
    (name "randomjungle")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://www.imbs-luebeck.de/imbs/sites/default/files/u59/"
             "randomjungle-" version ".tar_.gz"))
       (sha256
        (base32
         "12c8rf30cla71swx2mf4ww9mfd8jbdw5lnxd7dxhyw1ygrvg6y4w"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list (string-append "--with-boost="
                            (assoc-ref %build-inputs "boost")))
       #:phases
       (modify-phases %standard-phases
         (add-before
          'configure 'set-CXXFLAGS
          (lambda _
            (setenv "CXXFLAGS" "-fpermissive ")
            #t)))))
    (inputs
     `(("boost" ,boost)
       ("gsl" ,gsl)
       ("libxml2" ,libxml2)
       ("zlib" ,zlib)))
    (native-inputs
     `(("gfortran" ,gfortran)
       ("gfortran:lib" ,gfortran "lib")))
    ;; Non-portable assembly instructions are used so building fails on
    ;; platforms other than x86_64 or i686.
    (supported-systems '("x86_64-linux" "i686-linux"))
    (home-page "http://www.imbs-luebeck.de/imbs/de/node/227/")
    (synopsis "Implementation of the Random Forests machine learning method")
    (description
     "Random Jungle is an implementation of Random Forests.  It is supposed to
analyse high dimensional data.  In genetics, it can be used for analysing big
Genome Wide Association (GWA) data.  Random Forests is a powerful machine
learning method.  Most interesting features are variable selection, missing
value imputation, classifier creation, generalization error estimation and
sample proximities between pairs of cases.")
    (license license:gpl3+)))

(define-public shogun
  (package
    (name "shogun")
    (version "4.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "ftp://shogun-toolbox.org/shogun/releases/"
             (version-major+minor version)
             "/sources/shogun-" version ".tar.bz2"))
       (sha256
        (base32
         "159nlijnb7mnrv9za80wnm1shwvy45hgrqzn51hxy7gw4z6d6fdb"))
       (modules '((guix build utils)
                  (ice-9 rdelim)))
       (snippet
        '(begin
           ;; Remove non-free sources and files referencing them
           (for-each delete-file
                     (find-files "src/shogun/classifier/svm/"
                                 "SVMLight\\.(cpp|h)"))
           (for-each delete-file
                     (find-files "examples/undocumented/libshogun/"
                                 (string-append
                                  "(classifier_.*svmlight.*|"
                                  "evaluation_cross_validation_locked_comparison).cpp")))
           ;; Remove non-free functions.
           (define (delete-ifdefs file)
             (with-atomic-file-replacement file
               (lambda (in out)
                 (let loop ((line (read-line in 'concat))
                            (skipping? #f))
                   (if (eof-object? line)
                       #t
                       (let ((skip-next?
                              (or (and skipping?
                                       (not (string-prefix?
                                             "#endif //USE_SVMLIGHT" line)))
                                  (string-prefix?
                                   "#ifdef USE_SVMLIGHT" line))))
                         (when (or (not skipping?)
                                   (and skipping? (not skip-next?)))
                           (display line out))
                         (loop (read-line in 'concat) skip-next?)))))))
           (for-each delete-ifdefs (find-files "src/shogun/kernel/"
                                               "^Kernel\\.(cpp|h)"))))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f ;no check target
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'delete-broken-symlinks
           (lambda _
             (for-each delete-file '("applications/arts/data"
                                     "applications/asp/data"
                                     "applications/easysvm/data"
                                     "applications/msplicer/data"
                                     "applications/ocr/data"
                                     "examples/documented/data"
                                     "examples/documented/matlab_static"
                                     "examples/documented/octave_static"
                                     "examples/undocumented/data"
                                     "examples/undocumented/matlab_static"
                                     "examples/undocumented/octave_static"
                                     "tests/integration/data"
                                     "tests/integration/matlab_static"
                                     "tests/integration/octave_static"
                                     "tests/integration/python_modular/tests"))
             #t))
         (add-after 'unpack 'change-R-target-path
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* '("src/interfaces/r_modular/CMakeLists.txt"
                            "src/interfaces/r_static/CMakeLists.txt"
                            "examples/undocumented/r_modular/CMakeLists.txt")
               (("\\$\\{R_COMPONENT_LIB_PATH\\}")
                (string-append (assoc-ref outputs "out")
                               "/lib/R/library/")))
             #t))
         (add-after 'unpack 'fix-octave-modules
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* '("src/interfaces/octave_modular/CMakeLists.txt"
                            "src/interfaces/octave_static/CMakeLists.txt")
               (("^include_directories\\(\\$\\{OCTAVE_INCLUDE_DIRS\\}")
                "include_directories(${OCTAVE_INCLUDE_DIRS} ${OCTAVE_INCLUDE_DIRS}/octave"))

             ;; change target directory
             (substitute* "src/interfaces/octave_modular/CMakeLists.txt"
               (("\\$\\{OCTAVE_OCT_LOCAL_API_FILE_DIR\\}")
                (string-append (assoc-ref outputs "out")
                               "/share/octave/packages")))
             #t))
         (add-before 'build 'set-HOME
           ;; $HOME needs to be set at some point during the build phase
           (lambda _ (setenv "HOME" "/tmp") #t)))
       #:configure-flags
       (list "-DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE"
             "-DUSE_SVMLIGHT=OFF" ;disable proprietary SVMLIGHT
             ;;"-DJavaModular=ON" ;requires unpackaged jblas
             ;;"-DRubyModular=ON" ;requires unpackaged ruby-narray
             ;;"-DPerlModular=ON" ;"FindPerlLibs" does not exist
             ;;"-DLuaModular=ON"  ;fails because lua doesn't build pkgconfig file
             "-DOctaveModular=ON"
             "-DOctaveStatic=ON"
             "-DPythonModular=ON"
             "-DPythonStatic=ON"
             "-DRModular=ON"
             "-DRStatic=ON"
             "-DCmdLineStatic=ON")))
    (inputs
     `(("python" ,python)
       ("numpy" ,python-numpy)
       ("r-minimal" ,r-minimal)
       ("octave" ,octave)
       ("swig" ,swig)
       ("hdf5" ,hdf5)
       ("atlas" ,atlas)
       ("arpack" ,arpack-ng)
       ("lapack" ,lapack)
       ("glpk" ,glpk)
       ("libxml2" ,libxml2)
       ("lzo" ,lzo)
       ("zlib" ,zlib)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    ;; Non-portable SSE instructions are used so building fails on platforms
    ;; other than x86_64.
    (supported-systems '("x86_64-linux"))
    (home-page "http://shogun-toolbox.org/")
    (synopsis "Machine learning toolbox")
    (description
     "The Shogun Machine learning toolbox provides a wide range of unified and
efficient Machine Learning (ML) methods.  The toolbox seamlessly allows to
combine multiple data representations, algorithm classes, and general purpose
tools.  This enables both rapid prototyping of data pipelines and extensibility
in terms of new algorithms.")
    (license license:gpl3+)))

(define-public r-adaptivesparsity
  (package
    (name "r-adaptivesparsity")
    (version "1.4")
    (source (origin
              (method url-fetch)
              (uri (cran-uri "AdaptiveSparsity" version))
              (sha256
               (base32
                "1az7isvalf3kmdiycrfl6s9k9xqk22k1mc6rh8v0jmcz402qyq8z"))))
    (properties
     `((upstream-name . "AdaptiveSparsity")))
    (build-system r-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'link-against-armadillo
           (lambda _
             (substitute* "src/Makevars"
               (("PKG_LIBS=" prefix)
                (string-append prefix "-larmadillo"))))))))
    (propagated-inputs
     `(("r-rcpp" ,r-rcpp)
       ("r-rcpparmadillo" ,r-rcpparmadillo)))
    (inputs
     `(("armadillo" ,armadillo)))
    (home-page "https://cran.r-project.org/web/packages/AdaptiveSparsity")
    (synopsis "Adaptive sparsity models")
    (description
     "This package implements the Figueiredo machine learning algorithm for
adaptive sparsity and the Wong algorithm for adaptively sparse gaussian
geometric models.")
    (license license:lgpl3+)))

(define-public r-kernlab
  (package
    (name "r-kernlab")
    (version "0.9-25")
    (source
     (origin
       (method url-fetch)
       (uri (cran-uri "kernlab" version))
       (sha256
        (base32
         "0qnaq9x3j2xc6jrmmd98wc6hkzch487s4p3a9lnc00xvahkhgpmr"))))
    (build-system r-build-system)
    (home-page "https://cran.r-project.org/web/packages/kernlab")
    (synopsis "Kernel-based machine learning tools")
    (description
     "This package provides kernel-based machine learning methods for
classification, regression, clustering, novelty detection, quantile regression
and dimensionality reduction.  Among other methods @code{kernlab} includes
Support Vector Machines, Spectral Clustering, Kernel PCA, Gaussian Processes
and a QP solver.")
    (license license:gpl2)))

(define-public dlib
  (package
    (name "dlib")
    (version "19.7")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://dlib.net/files/dlib-" version ".tar.bz2"))
              (sha256
               (base32
                "1mljz02kwkrbggyncxv5fpnyjdybw2qihaacb3js8yfkw12vwpc2"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Delete ~13MB of bundled dependencies.
                  (delete-file-recursively "dlib/external")
                  (delete-file-recursively "docs/dlib/external")
                  #t))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-asserts
           (lambda _
             ;; config.h recommends explicitly enabling or disabling asserts
             ;; when building as a shared library. By default neither is set.
             (substitute* "dlib/config.h"
               (("^//#define DLIB_DISABLE_ASSERTS") "#define DLIB_DISABLE_ASSERTS"))
             #t))
         (add-after 'disable-asserts 'disable-failing-tests
           (lambda _
             ;; One test times out on MIPS, so we need to disable it.
             ;; Others are flaky on some platforms.
             (let* ((system ,(or (%current-target-system)
                                 (%current-system)))
                    (disabled-tests (cond
                                     ((string-prefix? "mips64" system)
                                      '("object_detector" ; timeout
                                        "data_io"))
                                     ((string-prefix? "armhf" system)
                                      '("learning_to_track"))
                                     ((string-prefix? "i686" system)
                                      '("optimization"))
                                     (else '()))))
               (for-each
                (lambda (test)
                  (substitute* "dlib/test/makefile"
                    (((string-append "SRC \\+= " test "\\.cpp")) "")))
                disabled-tests)
               #t)))
         (replace 'check
           (lambda _
             ;; No test target, so we build and run the unit tests here.
             (let ((test-dir (string-append "../dlib-" ,version "/dlib/test")))
               (with-directory-excursion test-dir
                 (and (zero? (system* "make" "-j" (number->string (parallel-job-count))))
                      (zero? (system* "./dtest" "--runall")))))))
         (add-after 'install 'delete-static-library
           (lambda* (#:key outputs #:allow-other-keys)
             (delete-file (string-append (assoc-ref outputs "out")
                                         "/lib/libdlib.a"))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("giflib" ,giflib)
       ("lapack" ,lapack)
       ("libjpeg" ,libjpeg)
       ("libpng" ,libpng)
       ("libx11" ,libx11)
       ("openblas" ,openblas)
       ("zlib" ,zlib)))
    (synopsis
     "Toolkit for making machine learning and data analysis applications in C++")
    (description
     "Dlib is a modern C++ toolkit containing machine learning algorithms and
tools.  It is used in both industry and academia in a wide range of domains
including robotics, embedded devices, mobile phones, and large high performance
computing environments.")
    (home-page "http://dlib.net")
    (license license:boost1.0)))

(define-public python-scikit-learn
  (package
    (name "python-scikit-learn")
    (version "0.19.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/scikit-learn/scikit-learn/archive/"
             version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "18n8775kyfwbvcjjjzda9c5sqy4737c0hrmj6qj1ps2jmlqzair9"))
       (patches (search-patches
                "python-scikit-learn-fix-test-non-determinism.patch"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'check)
         (add-after 'install 'check
           ;; Running tests from the source directory requires
           ;; an "inplace" build with paths relative to CWD.
           ;; http://scikit-learn.org/stable/developers/advanced_installation.html#testing
           ;; Use the installed version instead.
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (add-installed-pythonpath inputs outputs)
             ;; some tests require access to "$HOME"
             (setenv "HOME" "/tmp")
             ;; Step out of the source directory just to be sure.
             (chdir "..")
             (zero? (system* "nosetests" "-v" "sklearn")))))))
    (inputs
     `(("openblas" ,openblas)))
    (native-inputs
     `(("python-nose" ,python-nose)
       ("python-cython" ,python-cython)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-scipy" ,python-scipy)))
    (home-page "http://scikit-learn.org/")
    (synopsis "Machine Learning in Python")
    (description
     "Scikit-learn provides simple and efficient tools for data
mining and data analysis.")
    (license license:bsd-3)))

(define-public python2-scikit-learn
  (package-with-python2 python-scikit-learn))

(define-public python-autograd
  (let* ((commit "442205dfefe407beffb33550846434baa90c4de7")
         (revision "0")
         (version (git-version "0.0.0" revision commit)))
    (package
      (name "python-autograd")
      (home-page "https://github.com/HIPS/autograd")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url home-page)
                      (commit commit)))
                (sha256
                 (base32
                  "189sv2xb0mwnjawa9z7mrgdglc1miaq93pnck26r28fi1jdwg0z4"))
                (file-name (git-file-name name version))))
      (version version)
      (build-system python-build-system)
      (native-inputs
       `(("python-nose" ,python-nose)
         ("python-pytest" ,python-pytest)))
      (propagated-inputs
       `(("python-future" ,python-future)
         ("python-numpy" ,python-numpy)))
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (replace 'check
                      (lambda _
                        (invoke "py.test" "-v"))))))
      (synopsis "Efficiently computes derivatives of NumPy code")
      (description "Autograd can automatically differentiate native Python and
NumPy code.  It can handle a large subset of Python's features, including loops,
ifs, recursion and closures, and it can even take derivatives of derivatives
of derivatives.  It supports reverse-mode differentiation
(a.k.a. backpropagation), which means it can efficiently take gradients of
scalar-valued functions with respect to array-valued arguments, as well as
forward-mode differentiation, and the two can be composed arbitrarily.  The
main intended application of Autograd is gradient-based optimization.")
      (license license:expat))))

(define-public python2-autograd
  (package-with-python2 python-autograd))
