;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012 Nikita Karetnikov <nikita@karetnikov.org>
;;; Copyright © 2014 David Thompson <davet@gnu.org>
;;; Copyright © 2015 Paul van der Walt <paul@denknerd.org>
;;; Copyright © 2014, 2015 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015, 2017 Cyril Roelandt <tipecaml@gmail.com>
;;; Copyright © 2015 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2015 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2015, 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017 Leo Famulari <leo@famulari.name>
;;; Copyright © 2016 Christopher Allan Webber <cwebber@dustycloud.org>
;;; Copyright © 2016, 2017 Danny Milosavljevic <dannym+a@scratchpost.org>
;;; Copyright © 2016 Roel Janssen <roel@gnu.org>
;;; Copyright © 2016 Sou Bunnbu <iyzsong@gmail.com>
;;; Copyright © 2016 Troy Sankey <sankeytms@gmail.com>
;;; Copyright © 2016 Lukas Gradl <lgradl@openmailbox.org>
;;; Copyright © 2016 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2016, 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2017 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2017 Thomas Danckaert <post@thomasdanckaert.be>
;;; Copyright © 2017 Arun Isaac <arunisaac@systemreboot.net>
;;; Copyright © 2017 Frederick M. Muriithi <fredmanglis@gmail.com>
;;; Copyright © 2017 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2017 Kei Kebreau <kkebreau@posteo.net>
;;; Copyright © 2017 Nils Gillmann <ng0@n0.is>
;;; Copyright © 2015, 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016, 2017, 2018 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2017 Ludovic Courtès <ludo@gnu.org>
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

(define-module (gnu packages check)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages time)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system python)
  #:use-module (guix build-system trivial))

(define-public check
  (package
    (name "check")
    (version "0.12.0")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "https://github.com/libcheck/check/releases/download/"
                          version "/check-" version ".tar.gz"))
      (sha256
       (base32
        "0d22h8xshmbpl9hba9ch3xj8vb9ybm5akpsbbh7yj07fic4h2hj6"))))
    (build-system gnu-build-system)
    (home-page "https://libcheck.github.io/check/")
    (synopsis "Unit test framework for C")
    (description
     "Check is a unit testing framework for C.  It features a simple
interface for defining unit tests, putting little in the way of the
developer.  Tests are run in a separate address space, so Check can
catch both assertion failures and code errors that cause segmentation
faults or other signals.  The output from unit tests can be used within
source code editors and IDEs.")
    (license license:lgpl2.1+)))

(define-public cunit
  (package
    (name "cunit")
    (version "2.1-3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/cunit/CUnit/"
                           version "/CUnit-" version ".tar.bz2"))
       (sha256
        (base32
         "057j82da9vv4li4z5ri3227ybd18nzyq81f6gsvhifs5z0vr3cpm"))))
    (build-system gnu-build-system)
    (arguments '(#:phases
                 (modify-phases %standard-phases
                   (add-before 'configure 'autoconf
                     (lambda _
                       (zero? (system* "autoreconf" "-vfi")))))))
    (native-inputs
     `(("automake" ,automake)
       ("autoconf" ,autoconf)
       ("libtool" ,libtool)))
    (home-page "http://cunit.sourceforge.net/")
    (synopsis "Automated testing framework for C")
    (description
     "CUnit is a lightweight system for writing, administering, and running
unit tests in C.  It provides C programmers with basic testing functionality
with a flexible variety of user interfaces.")
    (license license:gpl2+)))

(define-public cppunit
  (package
    (name "cppunit")
    (version "1.13.2")
    (source (origin
             (method url-fetch)
              (uri (string-append "http://dev-www.libreoffice.org/src/"
                                  name "-" version ".tar.gz"))
             (sha256
              (base32
               "17s2kzmkw3kfjhpp72rfppyd7syr7bdq5s69syj2nvrlwd3d4irz"))))
    ;; Explicitly link with libdl. This is expected to be done by packages
    ;; relying on cppunit for their tests. However, not all of them do.
    ;; If we added the linker flag to such packages, we would pollute all
    ;; binaries, not only those used for testing.
    (arguments
     `(#:make-flags '("LDFLAGS=-ldl")))
    (build-system gnu-build-system)
    (home-page "https://wiki.freedesktop.org/www/Software/cppunit/")
    (synopsis "Unit testing framework for C++")
    (description "CppUnit is the C++ port of the famous JUnit framework for
unit testing.  Test output is in XML for automatic testing and GUI based for
supervised tests.")
    (license license:lgpl2.1))) ; no copyright notices. LGPL2.1 is in the tarball

;; Some packages require this newer version of cppunit.  However, it needs
;; C++11 support, which is not enabled by default in our current GCC, and
;; updating in-place would require adding CXXFLAGS to many dependent packages.
;; Thus, keep as a separate variable for now.
;; TODO: Remove this when our default GCC is updated to 6 or higher.
(define-public cppunit-1.14
  (package
    (inherit cppunit)
    (version "1.14.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dev-www.libreoffice.org/src/"
                                  "cppunit-" version ".tar.gz"))
              (sha256
               (base32
                "1027cyfx5gsjkdkaf6c2wnjh68882grw8n672018cj3vs9lrhmix"))))))

(define-public catch-framework
  (package
    (name "catch")
    (version "1.3.5")                  ;Sub-minor is the build number
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/philsquared/Catch")
                    ;; Semi-arbitrary.
                    (commit "ae5ee2cf63d6d67bd1369b512d2a7b60b571c907")))
              (file-name (string-append name "-" version))
              (sha256
               (base32
                "1yfb3lxv929szqy1nw9xw3d45wzkppziqshkjxvrb1fdmf46x564"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let* ((source (assoc-ref %build-inputs "source"))
                          (output (assoc-ref %outputs "out"))
                          (incdir (string-append output "/include"))
                          (docdir (string-append output "/share/doc/catch-"
                                                 ,version)))
                     (begin
                       (for-each mkdir-p (list incdir docdir))
                       (install-file (string-append source
                                                 "/single_include/catch.hpp")
                                     incdir)
                       (copy-recursively (string-append source "/docs")
                                         docdir))))))
    (home-page "http://catch-lib.net/")
    (synopsis "Automated test framework for C++ and Objective-C")
    (description
     "Catch stands for C++ Automated Test Cases in Headers and is a
multi-paradigm automated test framework for C++ and Objective-C.")
    (license license:boost1.0)))

(define-public cmdtest
  (package
    (name "cmdtest")
    (version "0.32")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://git.liw.fi/cmdtest/snapshot/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "1jmfiyrrqmpvwdb273bkb8hjaf4rwx9njblx29pmr7giyahskwi5"))))
    (build-system python-build-system)
    (arguments
     `(#:python ,python-2
       #:phases
       (modify-phases %standard-phases
         ;; check phase needs to be run before the build phase. If not, the
         ;; coverage test runner looks for tests for the built source files,
         ;; and fails.
         (delete 'check)
         (add-before 'build 'check
           (lambda _
             (substitute* "yarn"
               (("/bin/sh") (which "sh")))
             ;; yarn uses python2-ttystatus to print messages.
             ;; python2-ttystatus requires /dev/tty which is not present in
             ;; the build environment. Hence assuming-failure test fails.
             (delete-file "yarn.tests/assuming-failure.script")
             (delete-file "yarn.tests/assuming-failure.stdout")
             (zero? (system* "python" "setup.py" "check")))))))
    (native-inputs
     `(("python2-coverage-test-runner" ,python2-coverage-test-runner)))
    (propagated-inputs
     `(("python2-cliapp" ,python2-cliapp)
       ("python2-markdown" ,python2-markdown)
       ("python2-ttystatus" ,python2-ttystatus)))
    (home-page "https://liw.fi/cmdtest/")
    (synopsis "Black box Unix program tester")
    (description
     "@code{cmdtest} black box tests Unix command line tools.  Roughly, it is
given a command line and input files, and the expected output, and it verifies
that the command line produces the expected output.  If not, it reports a
problem, and shows the differences.")
    (license license:gpl3+)))

(define-public cmocka
  (package
    (name "cmocka")
    (version "1.1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://cmocka.org/files/"
                                  (version-major+minor version) "/cmocka-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1283zi9qf5613g8iadm1fxmjh4rzxqd5np2j3lcpgairf25g8bph"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f)) ; No test target
    (home-page "https://cmocka.org/")
    (synopsis "Unit testing framework for C")
    (description "Cmocka is a unit testing framework for C with support for
mock objects.  It only requires the standard C library, and works with
different compilers.  Cmocka supports several different message output formats
like Test Anything Protocol, Subunit, xUnit XML or the original cmockery output
format.")
    (license license:asl2.0)))

(define-public cppcheck
  (package
    (name "cppcheck")
    (version "1.83")
    (source (origin
      (method url-fetch)
      (uri (string-append "https://github.com/danmar/cppcheck/archive/"
                          version ".tar.gz"))
      (sha256
       (base32 "15ghxwmyy09cd9mi008k4jn09c441j86qyaa4dz0is7f5dv5cdkx"))
      (file-name (string-append name "-" version ".tar.gz"))))
    (build-system cmake-build-system)
    (home-page "http://cppcheck.sourceforge.net")
    (synopsis "Static C/C++ code analyzer")
    (description "Cppcheck is a static code analyzer for C and C++.  Unlike
C/C++ compilers and many other analysis tools it does not detect syntax errors
in the code.  Cppcheck primarily detects the types of bugs that the compilers
normally do not detect.  The goal is to detect only real errors in the code
(i.e. have zero false positives).")
    (license license:gpl3+)))

(define-public go-gopkg.in-check.v1
  (let ((commit "20d25e2804050c1cd24a7eea1e7a6447dd0e74ec")
        (revision "0"))
    (package
      (name "go-gopkg.in-check.v1")
      (version (git-version "0.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/go-check/check.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0k1m83ji9l1a7ng8a7v40psbymxasmssbrrhpdv2wl4rhs0nc3np"))))
      (build-system go-build-system)
      (arguments
       '(#:import-path "gopkg.in/check.v1"))
      (synopsis "Rich testing extension for Go's testing package")
      (description
       "@code{check} is a rich testing extension for Go's testing package.")
      (home-page "https://github.com/go-check/check")
      (license license:bsd-2))))

(define-public go-github.com-smartystreets-gunit
  (package
    (name "go-github.com-smartystreets-gunit")
    (version "1.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/smartystreets/gunit")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "00m4zg0kdj49mnpmf9klb44ba71p966xsk6zknrzqgfc8119f35z"))))
    (build-system go-build-system)
    (arguments
     '(;; TODO: This package depends on go-github.com-smartystreets-assertions
       ;; for running the tests, but go-github.com-smartystreets-assertions
       ;; depends on this package, so break this loop by not running the tests
       ;; for this package.
       #:tests? #f
       #:import-path "github.com/smartystreets/gunit"))
    (synopsis "Testing tool for Go, in the style of xUnit")
    (description
     "@code{gunit} allows the test author to use a struct as the scope for a
group of related test cases, in the style of xUnit fixtures.  This makes
extraction of setup/teardown behavior (as well as invoking the system under
test) much simpler.")
    (home-page "https://github.com/smartystreets/gunit")
    (license license:expat)))

(define-public go-github.com-smartystreets-assertions
  (package
    (name "go-github.com-smartystreets-assertions")
    (version "1.8.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/smartystreets/assertions")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1j0adgbykl55rf2945g0n5bmqdsnjcqlx5dcmpfh4chki43hiwg9"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/smartystreets/assertions"))
    (native-inputs
     `(("go-github.com-smartystreets-gunit" ,go-github.com-smartystreets-gunit)))
    (synopsis "Assertions for testing with Go")
    (description
     "The @code{assertions} package provides convinient assertion functions
for writing tests in Go.")
    (home-page "https://github.com/smartystreets/assertions")
    (license license:expat)))

(define-public go-github.com-smartystreets-goconvey
  (package
    (name "go-github.com-smartystreets-goconvey")
    (version "1.6.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/smartystreets/goconvey")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1ph18rkl3ns3fgin5i4j54w5a69grrmf3apcsmnpdn1wlrbs3dxh"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/smartystreets/goconvey"))
    (propagated-inputs
     `(("go-github.com-jtolds-gls" ,go-github.com-jtolds-gls)
       ("go-github.com-smartystreets-assertions" ,go-github.com-smartystreets-assertions)))
    (synopsis "Go testing tool with both a web and terminal user interface")
    (description
     "GoConvey is a testing tool for Go. It integrates with go test, can show
test coverage and has a web user interface that will refresh automatically.")
    (home-page "https://github.com/smartystreets/goconvey")
    (license license:expat)))

(define-public googletest
  (package
    (name "googletest")
    (version "1.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/google/googletest/archive/"
                           "release-" version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1n5p1m2m3fjrjdj752lf92f9wq3pl5cbsfrb49jqbg52ghkz99jq"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags '("-DBUILD_SHARED_LIBS=ON")))
    (native-inputs
     `(("python-2" ,python-2)))
    (home-page "https://github.com/google/googletest/")
    (synopsis "Test discovery and XUnit test framework")
    (description "Google Test features an XUnit test framework, automated test
discovery, death tests, assertions, parameterized tests and XML test report
generation.")
    (license license:bsd-3)))

(define-public cpputest
  (package
    (name "cpputest")
    (version "3.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/cpputest/cpputest/releases/download/v"
                           version "/cpputest-" version ".tar.gz"))
       (sha256
        (base32
         "0mk48xd3klyqi7wf3f4wn4zqxxzmvrhhl32r25jzrixzl72wq7f8"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("googletest" ,googletest)))
    (home-page "https://cpputest.github.io/")
    (synopsis "Unit testing and mocking framework for C/C++")
    (description
     "CppUTest is a C/C++ based unit xUnit test framework.  It is written in
C++ but is used in C and C++ projects and frequently used in embedded systems
but it works for any C/C++ project.")
    (license license:bsd-3)))

(define-public python-parameterized
  (package
    (name "python-parameterized")
    (version "0.6.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "parameterized" version))
       (sha256
        (base32
         "1qj1939shm48d9ql6fm1nrdy4p7sdyj8clz1szh5swwpf1qqxxfa"))))
    (build-system python-build-system)
    (arguments '(#:tests? #f)) ; there are no tests
    (home-page "https://github.com/wolever/parameterized")
    (synopsis "Parameterized testing with any Python test framework")
    (description
     "Parameterized is a Python library that aims to fix parameterized testing
for every Python test framework.  It supports nose, py.test, and unittest.")
    (license license:bsd-2)))

(define-public python2-parameterized
  (package-with-python2 python-parameterized))

(define-public python-mock
  (package
    (name "python-mock")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "mock" version))
       (sha256
        (base32
         "1flbpksir5sqrvq2z0dp8sl4bzbadg21sj4d42w3klpdfvgvcn5i"))))
    (propagated-inputs
     `(("python-pbr" ,python-pbr-minimal)
       ("python-six" ,python-six)))
    (build-system python-build-system)
    (native-inputs
     `(("python-unittest2" ,python-unittest2)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (zero? (system* "unit2")))))))
    (home-page "https://github.com/testing-cabal/mock")
    (synopsis "Python mocking and patching library for testing")
    (description
     "Mock is a library for testing in Python.  It allows you to replace parts
of your system under test with mock objects and make assertions about how they
have been used.")
    (properties `((python2-variant . ,(delay python2-mock))))
    (license license:expat)))

(define-public python2-mock
  (let ((base (package-with-python2
               (strip-python2-variant python-mock))))
    (package (inherit base)
      (propagated-inputs
       `(("python2-functools32" ,python2-functools32)
         ("python2-funcsigs" ,python2-funcsigs)
         ,@(package-propagated-inputs base))))))

(define-public python-nose
  (package
    (name "python-nose")
    (version "1.3.7")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "nose" version))
        (sha256
          (base32
            "164a43k7k2wsqqk1s6vavcdamvss4mz0vd6pwzv2h9n8rgwzxgzi"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: test suite fails
    (home-page "http://readthedocs.org/docs/nose/")
    (synopsis "Python testing library")
    (description
     "Nose extends the unittest library to make testing easier.")
    (license license:lgpl2.0+)))

(define-public python2-nose
  (package-with-python2 python-nose))

(define-public python-nose2
  (package
    (name "python-nose2")
    (version "0.6.5")
      (source
        (origin
          (method url-fetch)
          (uri (pypi-uri "nose2" version))
          (sha256
           (base32
            "1x4zjq1zlyrh8b9ba0cmafd3w94pxhid408kibyjd3s6h1lap6s7"))))
    (build-system python-build-system)
    (arguments `(#:tests? #f)) ; 'module' object has no attribute 'collector'
    (propagated-inputs
     `(("python-cov-core" ,python-cov-core)
       ("python-pytest-cov" ,python-pytest-cov)
       ("python-six" ,python-six)))
    (home-page "https://github.com/nose-devs/nose2")
    (synopsis "Next generation of nicer testing for Python")
    (description
     "Nose2 is the next generation of nicer testing for Python, based on the
plugins branch of unittest2.  Nose2 aims to improve on nose by providing a
better plugin api, being easier for users to configure, and simplifying internal
interfaces and processes.")
    (license license:bsd-2)))

(define-public python2-nose2
  (package-with-python2 python-nose2))

(define-public python-unittest2
  (package
    (name "python-unittest2")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "unittest2" version))
       (patches
        (search-patches "python-unittest2-python3-compat.patch"
                        "python-unittest2-remove-argparse.patch"))
       (sha256
        (base32
         "0y855kmx7a8rnf81d3lh5lyxai1908xjp0laf4glwa4c8472m212"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (zero? (system* "python" "-m" "unittest2" "discover" "--verbose")))))))
    (propagated-inputs
     `(("python-six" ,python-six)
       ("python-traceback2" ,python-traceback2)))
    (home-page "http://pypi.python.org/pypi/unittest2")
    (synopsis "Python unit testing library")
    (description
     "Unittest2 is a replacement for the unittest module in the Python
standard library.")
    (license license:psfl)))

(define-public python2-unittest2
  (package-with-python2 python-unittest2))

(define-public python-pytest
  (package
    (name "python-pytest")
    (version "3.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest" version))
       (sha256
        (base32
         "0g6w86ks73fnrnsyib9ii2rbyx830vn7aglsjqz9v1n2xwbndyi7"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'check 'disable-invalid-tests
           (lambda _
             ;; Some tests involves the /usr directory, and fails.
             (substitute* "testing/test_argcomplete.py"
               (("def test_remove_dir_prefix\\(self\\):")
                "@pytest.mark.xfail\n    def test_remove_dir_prefix(self):"))
             (substitute* "testing/test_argcomplete.py"
               (("def test_remove_dir_prefix" line)
                (string-append "@pytest.mark.skip"
                               "(reason=\"Assumes that /usr exists.\")\n    "
                               line)))
             #t)))))
    (propagated-inputs
     `(("python-py" ,python-py)))
    (native-inputs
     `(;; Tests need the "regular" bash since 'bash-final' lacks `compgen`.
       ("bash" ,bash)
       ("python-hypothesis" ,python-hypothesis)
       ("python-nose" ,python-nose)
       ("python-mock" ,python-mock)
       ("python-setuptools-scm" ,python-setuptools-scm)))
    (home-page "http://pytest.org")
    (synopsis "Python testing library")
    (description
     "Pytest is a testing tool that provides auto-discovery of test modules
and functions, detailed info on failing assert statements, modular fixtures,
and many external plugins.")
    (license license:expat)))

(define-public python2-pytest
  (package-with-python2 python-pytest))

(define-public python-pytest-bootstrap
  (package
    (inherit python-pytest)
    (name "python-pytest-bootstrap")
    (native-inputs `(("python-setuptools-scm" ,python-setuptools-scm)))
    (arguments `(#:tests? #f))))

(define-public python2-pytest-bootstrap
  (package-with-python2 python-pytest-bootstrap))

(define-public python-pytest-cov
  (package
    (name "python-pytest-cov")
    (version "2.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "pytest-cov" version))
        (sha256
         (base32
          "03c2qc42r4bczyw93gd7n0qi1h1jfhw7fnbhi33c3vp1hs81gm2k"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
          (lambda _
            ;; options taken from tox.ini
            ;; TODO: make "--restructuredtext" tests pass. They currently fail
            ;; with "Duplicate implicit target name"
            (zero? (system* "python" "./setup.py" "check"
                            "--strict" "--metadata")))))))
    (propagated-inputs
     `(("python-coverage" ,python-coverage)
       ("python-pytest" ,python-pytest)))
    (home-page "https://github.com/pytest-dev/pytest-cov")
    (synopsis "Pytest plugin for measuring coverage")
    (description
     "Pytest-cov produces coverage reports.  It supports centralised testing and
distributed testing in both @code{load} and @code{each} modes.  It also
supports coverage of subprocesses.")
  (license license:expat)))

(define-public python2-pytest-cov
  (package-with-python2 python-pytest-cov))

(define-public python-pytest-runner
  (package
    (name "python-pytest-runner")
    (version "2.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-runner" version))
       (sha256
        (base32
         "1cw978kqqcq916b9gfns1qjqvg33c5ail5jhw9054dsynkm32flq"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; The fancy way of setting the version with setuptools_scm does not
         ;; seem to work here.
         (add-after 'unpack 'set-version
          (lambda _
            (substitute* "docs/conf.py"
              (("version = setuptools_scm\\.get_version\\(root='\\.\\.')")
               (string-append "version = \"" ,version "\"")))
            #t)))))
    (native-inputs
     `(("python-pytest" ,python-pytest-bootstrap)
       ("python-setuptools-scm" ,python-setuptools-scm)))
    (home-page "https://github.com/pytest-dev/pytest-runner")
    (synopsis "Invoke py.test as a distutils command")
    (description
     "This package provides a @command{pytest-runner} command that
@file{setup.py} files can use to run tests.")
    (license license:expat)))

(define-public python2-pytest-runner
  (package-with-python2 python-pytest-runner))

(define-public python-pytest-mock
  (package
    (name "python-pytest-mock")
    (version "1.6.3")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "pytest-mock" version))
        (sha256
         (base32
          "075v7b2wm5f839r1a30n21wfk5rfqp3d05q7zb9jlb2wmxki23cj"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-setuptools-scm" ,python-setuptools-scm)))
    (propagated-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "https://github.com/pytest-dev/pytest-mock/")
    (synopsis "Thin-wrapper around the mock package for easier use with py.test")
    (description
     "This plugin installs a @code{mocker} fixture which is a thin-wrapper
around the patching API provided by the @code{mock} package, but with the
benefit of not having to worry about undoing patches at the end of a test.
The mocker fixture has the same API as @code{mock.patch}, supporting the
same arguments.")
    (properties `((python2-variant . ,(delay python2-pytest-mock))))
    (license license:expat)))

(define-public python2-pytest-mock
  (let ((base (package-with-python2
                (strip-python2-variant python-pytest-mock))))
    (package (inherit base)
      (propagated-inputs
       `(("python2-mock" ,python2-mock)
         ,@(package-propagated-inputs base))))))

(define-public python-pytest-xdist
  (package
    (name "python-pytest-xdist")
    (version "1.14")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-xdist" version ".zip"))
       (sha256
        (base32
         "08rn2l39ds60xshs4js787l84pfckksqklfq2wq9x8ig2aci2pja"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; Remove pre-compiled .pyc files from source.
           (for-each delete-file-recursively
                     (find-files "." "__pycache__" #:directories? #t))
           (for-each delete-file (find-files "." "\\.pyc$"))
           #t))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ;FIXME: Some tests are failing.
       ;; #:phases
       ;; (modify-phases %standard-phases
       ;;   (delete 'check)
       ;;   (add-after 'install 'check
       ;;     (lambda* (#:key inputs outputs #:allow-other-keys)
       ;;       (add-installed-pythonpath inputs outputs)
       ;;       (zero? (system* "py.test" "-v")))))
    (native-inputs
     `(("unzip" ,unzip)
       ("python-setuptools-scm" ,python-setuptools-scm)))
    (propagated-inputs
     `(("python-execnet" ,python-execnet)
       ("python-pytest" ,python-pytest)
       ("python-py" ,python-py)))
    (home-page
     "https://github.com/pytest-dev/pytest-xdist")
    (synopsis
     "Plugin for py.test with distributed testing and loop-on-failing modes")
    (description
     "The pytest-xdist plugin extends py.test with some unique test execution
modes: parallelization, running tests in boxed subprocesses, the ability
to run tests repeatedly when failed, and the ability to run tests on multiple
Python interpreters or platforms.  It uses rsync to copy the existing
program code to a remote location, executes there, and then syncs the
result back.")
    (license license:expat)))

(define-public python2-pytest-xdist
  (package-with-python2 python-pytest-xdist))

(define-public python-scripttest
  (package
    (name "python-scripttest")
    (version "1.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://pypi.python.org/packages/source/s/scripttest/scripttest-"
             version ".tar.gz"))
       (sha256
        (base32
         "0f4w84k8ck82syys7yg9maz93mqzc8p5ymis941x034v44jzq74m"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "http://pythonpaste.org/scripttest/")
    (synopsis "Python library to test command-line scripts")
    (description "Scripttest is a Python helper library for testing
interactive command-line applications.  With it you can run a script in a
subprocess and see the output as well as any file modifications.")
    (license license:expat)))

(define-public python2-scripttest
  (package-with-python2 python-scripttest))

(define-public python-testtools-bootstrap
  (package
    (name "python-testtools-bootstrap")
    (version "2.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "testtools" version))
       (sha256
        (base32
         "0n8519lk8aaa91vymz842831181wf7fss98hyllhygi3z1nfq9sq"))))
    (build-system python-build-system)
    (arguments '(#:tests? #f))
    (propagated-inputs
     `(("python-extras" ,python-extras)
       ("python-fixtures" ,python-fixtures-bootstrap)
       ("python-mimeparse" ,python-mimeparse)
       ("python-pbr" ,python-pbr-minimal)
       ("python-six" ,python-six)
       ("python-traceback2" ,python-traceback2)
       ("python-unittest2" ,python-unittest2)))
    (home-page "https://github.com/testing-cabal/testtools")
    (synopsis
     "Extensions to the Python standard library unit testing framework")
    (description
     "This package is only for bootstrapping.  Do not use this.")
    (license license:psfl)))

(define-public python2-testtools-bootstrap
  (package-with-python2 python-testtools-bootstrap))

(define-public python-testtools
  (package
    (inherit python-testtools-bootstrap)
    (name "python-testtools")
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (replace 'check
                    (lambda _
                      (invoke "python" "-m" "testtools.run"
                              "testtools.tests.test_suite"))))))
    (propagated-inputs
     `(("python-extras" ,python-extras)
       ("python-fixtures" ,python-fixtures)
       ("python-mimeparse" ,python-mimeparse)
       ("python-pbr" ,python-pbr)
       ("python-six" ,python-six)
       ("python-traceback2" ,python-traceback2)
       ("python-unittest2" ,python-unittest2)))
    (native-inputs
     `(("python-testscenarios" ,python-testscenarios-bootstrap)))
    (description
     "Testtools extends the Python standard library unit testing framework to
provide matchers, more debugging information, and cross-Python
compatibility.")))

(define-public python2-testtools
  (package-with-python2 python-testtools))

(define-public python-testscenarios-bootstrap
  (package
    (name "python-testscenarios-bootstrap")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "testscenarios" version))
       (sha256
        (base32
         "1dm2aydqpv76vnsk1pw7k8n42hq58cfi4n1ixy7nyzpaj1mwnmy2"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (replace 'check
                    (lambda _
                      (invoke "python" "-m" "testtools.run"
                              "testscenarios.test_suite"))))))
    (propagated-inputs
     `(("python-pbr" ,python-pbr-minimal)
       ("python-testtools" ,python-testtools-bootstrap)))
    (home-page "https://launchpad.net/testscenarios")
    (synopsis "Pyunit extension for dependency injection")
    (description
     "This package is only for bootstrapping.  Don't use this.")
    (license (list license:bsd-3 license:asl2.0)))) ; at the user's option

(define-public python2-testscenarios-bootstrap
  (package-with-python2 python-testscenarios-bootstrap))

(define-public python-testscenarios
  (package
    (inherit python-testscenarios-bootstrap)
    (name "python-testscenarios")
    (propagated-inputs
     `(("python-pbr" ,python-pbr)
       ("python-testtools" ,python-testtools)))
    (description
     "Testscenarios provides clean dependency injection for Python unittest
style tests.")))

(define-public python2-testscenarios
  (package-with-python2 python-testscenarios))

;; Testresources requires python-pbr at runtime, but pbr needs it for its
;; own tests.  Hence this bootstrap variant.
(define-public python-testresources-bootstrap
  (package
    (name "python-testresources-bootstrap")
    (version "2.0.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "testresources" version))
              (sha256
               (base32
                "05s4dsli9g17m1r3b1gvwicbbgq011hnpb2b9qnj27ja2n11k7gf"))))
    (build-system python-build-system)
    (arguments '(#:tests? #f))
    (propagated-inputs
     `(("python-pbr" ,python-pbr-minimal)))
    (home-page "https://launchpad.net/testresources")
    (synopsis
     "Pyunit extension for managing test resources")
    (description
     "This package is only here for bootstrapping purposes.  Use the regular
testresources package instead.")
    (license (list license:bsd-3 license:asl2.0)))) ; at the user's option

(define-public python2-testresources-bootstrap
  (package-with-python2 python-testresources-bootstrap))

(define-public python-testresources
  (package
    (inherit python-testresources-bootstrap)
    (name "python-testresources")
    (propagated-inputs
     `(("python-pbr" ,python-pbr)))
    (arguments '())
    (native-inputs
     `(("python-fixtures" ,python-fixtures)
       ("python-testtols" ,python-testtools)))
    (description
     "Testresources is an extension to Python's unittest to allow declarative
use of resources by test cases.")))

(define-public python2-testresources
  (package-with-python2 python-testresources))

(define-public python-subunit-bootstrap
  (package
    (name "python-subunit-bootstrap")
    (version "1.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "python-subunit" version))
       (sha256
        (base32
         "1yii2gx3z6323as3iraj1yphj76dy7i3h6kj63pnc5y0hwjs5sgx"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-extras" ,python-extras)
       ("python-testtools" ,python-testtools-bootstrap)))
    (native-inputs
     `(("python-fixtures" ,python-fixtures-bootstrap)
       ("python-hypothesis" ,python-hypothesis)
       ("python-testscenarios" ,python-testscenarios-bootstrap)))
    (home-page "http://launchpad.net/subunit")
    (synopsis "Python implementation of the subunit protocol")
    (description
     "This package is here for bootstrapping purposes only.  Use the regular
python-subunit package instead.")
    (license (list license:bsd-3 license:asl2.0)))) ; at the user's option

(define-public python2-subunit-bootstrap
  (package-with-python2 python-subunit-bootstrap))

(define-public python-subunit
  (package
    (inherit python-subunit-bootstrap)
    (name "python-subunit")
    (propagated-inputs
     `(("python-extras" ,python-extras)
       ("python-testtools" ,python-testtools)))
    (native-inputs
     `(("python-fixtures" ,python-fixtures)
       ("python-hypothesis" ,python-hypothesis)
       ("python-testscenarios" ,python-testscenarios)))
    (description
     "Python-subunit is a Python implementation of the subunit test streaming
protocol.")))

(define-public python2-subunit
  (package-with-python2 python-subunit))

;; Fixtures requires python-pbr at runtime, but pbr uses fixtures for its
;; own tests.  Hence this bootstrap variant.
(define-public python-fixtures-bootstrap
  (package
    (name "python-fixtures-bootstrap")
    (version "3.0.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "fixtures" version))
              (sha256
               (base32
                "1vxj29bzz3rd4pcy51d05wng9q9dh4jq6wx92yklsm7i6h1ddw7w"))))
    (build-system python-build-system)
    (arguments `(#:tests? #f))
    (propagated-inputs
     `(("python-pbr-minimal" ,python-pbr-minimal)
       ("python-six" ,python-six)))
    (home-page "https://launchpad.net/python-fixtures")
    (synopsis "Python test fixture library")
    (description
     "This package is only used for bootstrapping.  Use the regular
python-fixtures package instead.")
    (license (list license:bsd-3 license:asl2.0)))) ; at user's option

(define-public python2-fixtures-bootstrap
  (package-with-python2 python-fixtures-bootstrap))

(define-public python-fixtures
  (package
    (inherit python-fixtures-bootstrap)
    (name "python-fixtures")
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (zero? (system* "python" "-m" "testtools.run"
                             "fixtures.test_suite")))))))
    (propagated-inputs
     ;; Fixtures uses pbr at runtime to check versions, etc.
     `(("python-pbr" ,python-pbr)
       ("python-six" ,python-six)))
    (native-inputs
     `(("python-mock" ,python-mock)
       ("python-testtools" ,python-testtools-bootstrap)))
    (description
     "Fixtures provides a way to create reusable state, useful when writing
Python tests.")))

(define-public python2-fixtures
  (package-with-python2 python-fixtures))

(define-public python-testrepository-bootstrap
  (package
    (name "python-testrepository-bootstrap")
     (version "0.0.20")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://pypi.python.org/packages/source/t/testrepository/testrepository-"
             version ".tar.gz"))
       (sha256
        (base32
         "1ssqb07c277010i6gzzkbdd46gd9mrj0bi0i8vn560n2k2y4j93m"))))
    (build-system python-build-system)
    (arguments '(#:tests? #f))
    (propagated-inputs
     `(("python-fixtures" ,python-fixtures-bootstrap)
       ("python-subunit" ,python-subunit-bootstrap)
       ("python-testtools" ,python-testtools-bootstrap)))
    (native-inputs
     `(("python-mimeparse" ,python-mimeparse)))
    (home-page "https://launchpad.net/testrepository")
    (synopsis "Database for Python test results")
    (description
     "Bootstrap package for python-testrepository.  Don't use this.")
    (license (list license:bsd-3 license:asl2.0)))) ; at user's option

(define-public python2-testrepository-bootstrap
  (package-with-python2 python-testrepository-bootstrap))

(define-public python-testrepository
  (package
    (inherit python-testrepository-bootstrap)
    (name "python-testrepository")
    (arguments
     ;; FIXME: Many tests are failing.
     '(#:tests? #f))
    (propagated-inputs
     `(("python-fixtures" ,python-fixtures)
       ("python-subunit" ,python-subunit)
       ("python-testtools" ,python-testtools)))
    (native-inputs
     `(("python-mimeparse" ,python-mimeparse)))
    (description "Testrepository provides a database of test results which can
be used as part of a developer's workflow to check things such as what tests
have failed since the last commit or what tests are currently failing.")))

(define-public python2-testrepository
  (package-with-python2 python-testrepository))

(define-public python-coverage
  (package
    (name "python-coverage")
    (version "4.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "coverage" version))
       (sha256
        (base32
         "097l4s3ssxm1vncsn0nw3a1pbzah28773q36c1ab9wz01r04973s"))))
    (build-system python-build-system)
    (arguments
     ;; FIXME: 95 tests failed, 539 passed, 6 skipped, 2 errors.
     '(#:tests? #f))
    (home-page "http://nedbatchelder.com/code/coverage")
    (synopsis "Code coverage measurement for Python")
    (description
     "Coverage measures code coverage, typically during test execution.  It
uses the code analysis tools and tracing hooks provided in the Python standard
library to determine which lines are executable, and which have been
executed.")
    (license license:bsd-3)))

(define-public python2-coverage
  (package-with-python2 python-coverage))

(define-public python-cov-core
  (package
    (name "python-cov-core")
    (version "1.15.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "cov-core" version))
        (sha256
         (base32
          "0k3np9ymh06yv1ib96sb6wfsxjkqhmik8qfsn119vnhga9ywc52a"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-coverage" ,python-coverage)))
    (home-page "https://github.com/schlamar/cov-core")
    (synopsis "Coverage plugin core for pytest-cov, nose-cov and nose2-cov")
    (description
     "This is a library package for use by @code{pytest-cov}, @code{nose-cov}
and @code{nose2-cov}.  It is useful for developing coverage plugins for these
testing frameworks.")
    (license license:expat)))

(define-public python2-cov-core
 (package-with-python2 python-cov-core))

(define-public python-testpath
  (package
    (name "python-testpath")
    (version "0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/jupyter/testpath/archive/"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "04kh3fgvmqz6cfcw79q70qwjz7ib7lxm27cc548iy2rpr33qqf55"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; this package does not even have a setup.py
       #:modules ((guix build python-build-system)
                  (guix build utils)
                  (srfi srfi-1))
       #:imported-modules (,@%python-build-system-modules
                           (srfi srfi-1))
       #:phases
       (modify-phases %standard-phases
         (delete 'install)
         (replace 'build
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((version (last
                              (string-split (assoc-ref inputs "python") #\-)))
                    (x.y (string-join (take (string-split version #\.) 2)
                                        "."))
                    (dir (string-append
                          (assoc-ref outputs "out")
                          "/lib/python" x.y "/site-packages/testpath")))
               (mkdir-p dir)
               (copy-recursively "testpath" dir))
             #t)))))
    (home-page "https://github.com/takluyver/testpath")
    (synopsis "Test utilities for code working with files and commands")
    (description
     "Testpath is a collection of utilities for Python code working with files
and commands.  It contains functions to check things on the file system, and
tools for mocking system commands and recording calls to those.")
    (license license:expat)))

(define-public python2-testpath
  (package-with-python2 python-testpath))

(define-public python-testlib
  (package
    (name "python-testlib")
    (version "0.6.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://pypi.python.org/packages/source/t/testlib/testlib-"
             version ".zip"))
       (sha256
        (base32 "1mz26cxn4x8bbgv0rn0mvj2z05y31rkc8009nvdlb3lam5b4mj3y"))))
    (build-system python-build-system)
    (native-inputs
     `(("unzip" ,unzip)))  ; for unpacking the source
    (synopsis "Python micro test suite harness")
    (description "A micro unittest suite harness for Python.")
    (home-page "https://github.com/trentm/testlib")
    (license license:expat)))

(define-public python2-testlib
  (package-with-python2 python-testlib))

;;; The software provided by this package was integrated into pytest 2.8.
(define-public python-pytest-cache
  (package
    (name "python-pytest-cache")
    (version "1.0")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "pytest-cache" version))
             (sha256
              (base32
               "1a873fihw4rhshc722j4h6j7g3nj7xpgsna9hhg3zn6ksknnhx5y"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-apipkg" ,python-apipkg)
       ("python-execnet" ,python-execnet)
       ("python-py" ,python-py)
       ("python-pytest" ,python-pytest)))
    (synopsis "Py.test plugin with mechanisms for caching across test runs")
    (description "The pytest-cache plugin provides tools to rerun failures from
the last py.test invocation.")
    (home-page "https://bitbucket.org/hpk42/pytest-cache/")
    (license license:expat)))

(define-public python2-pytest-cache
  (package-with-python2 python-pytest-cache))

(define-public python-pytest-localserver
  (package
    (name "python-pytest-localserver")
    (version "0.4.1")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "pytest-localserver" version))
             (sha256
              (base32
               "08f06rvj31wqf0vgmd1waya87r7vy6x8ck48lxl3dxy83q5gcam7"))))
    (build-system python-build-system)
    (arguments
      `(#:phases (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (zero? (system* "py.test" "--genscript=runtests.py"))
             (zero? (system* "py.test")))))))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-requests" ,python-requests)
       ("python-six" ,python-six)))
    (propagated-inputs
     `(("python-werkzeug" ,python-werkzeug)))
    (synopsis "Py.test plugin to test server connections locally")
    (description "Pytest-localserver is a plugin for the pytest testing
framework which enables you to test server connections locally.")
    (home-page "https://pypi.python.org/pypi/pytest-localserver")
    (license license:expat)))

(define-public python-pytest-xprocess
  (package
    (name "python-pytest-xprocess")
    (version "0.9.1")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "pytest-xprocess" version))
             (sha256
              (base32
               "17zlql1xqw3ywcgwwbqmw633aly99lab12hm02asr8awvg5603pp"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-pytest" ,python-pytest)
       ("python-pytest-cache" ,python-pytest-cache)
       ("python-psutil" ,python-psutil)))
    (synopsis "Pytest plugin to manage external processes across test runs")
    (description "Pytest-xprocess is an experimental py.test plugin for managing
processes across test runs.")
    (home-page "https://bitbucket.org/pytest-dev/pytest-xprocess")
    (license license:expat)))

(define-public python-pytest-subtesthack
  (package
    (name "python-pytest-subtesthack")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "pytest-subtesthack" version))
              (sha256
               (base32
                "15kzcr5pchf3id4ikdvlv752rc0j4d912n589l4rifp8qsj19l1x"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-pytest" ,python-pytest)))
    (synopsis "Set-up and tear-down fixtures for unit tests")
    (description "This plugin allows you to set up and tear down fixtures within
unit test functions that use @code{py.test}. This is useful for using
@command{hypothesis} inside py.test, as @command{hypothesis} will call the test
function multiple times, without setting up or tearing down fixture state as is
normally the case.")
    (home-page "https://github.com/untitaker/pytest-subtesthack/")
    (license license:unlicense)))

(define-public python2-pytest-subtesthack
  (package-with-python2 python-pytest-subtesthack))

(define-public python-hypothesis
  (package
    (name "python-hypothesis")
    (version "3.1.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "hypothesis" version))
              (sha256
               (base32
                "0qyqq9akm4vshhn8cngjc1qykcvsn7cz6dlm6njfsgpbraqrmbbw"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-flake8" ,python-flake8)
       ("python-pytest" ,python-pytest-bootstrap)))
    (synopsis "Library for property based testing")
    (description "Hypothesis is a library for testing your Python code against a
much larger range of examples than you would ever want to write by hand.  It’s
based on the Haskell library, Quickcheck, and is designed to integrate
seamlessly into your existing Python unit testing work flow.")
    (home-page "https://github.com/DRMacIver/hypothesis")
    (license license:mpl2.0)
    (properties `((python2-variant . ,(delay python2-hypothesis))))))

(define-public python2-hypothesis
  (let ((hypothesis (package-with-python2
                     (strip-python2-variant python-hypothesis))))
    (package (inherit hypothesis)
      (propagated-inputs
       `(("python2-enum34" ,python2-enum34)
         ,@(package-propagated-inputs hypothesis))))))

(define-public python-lit
  (package
    (name "python-lit")
    (version "0.5.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "lit" version))
        (sha256
         (base32
          "0z651m3vkbk85y41larnsjxrszkbi58x9gzml3lb6ga7qwcrsg97"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (invoke "python" "lit.py" "tests"))))))
    (native-inputs
     `(("llvm" ,llvm)))
    (home-page "https://llvm.org/")
    (synopsis "LLVM Software Testing Tool")
    (description "@code{lit} is a portable tool for executing LLVM and Clang
style test suites, summarizing their results, and providing indication of
failures.")
    (license license:ncsa)))

(define-public python2-lit
  (package-with-python2 python-lit))

(define-public python-pytest-pep8
  (package
    (name "python-pytest-pep8")
    (version "1.0.6")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "pytest-pep8" version))
              (sha256
               (base32
                "06032agzhw1i9d9qlhfblnl3dw5hcyxhagn7b120zhrszbjzfbh3"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f)) ; Fails with recent pytest and pep8. See upstream issues #8 and #12.
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (propagated-inputs
     `(("python-pep8" ,python-pep8)))
    (home-page "https://bitbucket.org/pytest-dev/pytest-pep8")
    (synopsis "Py.test plugin to check PEP8 requirements")
    (description "Pytest plugin for checking PEP8 compliance.")
    (license license:expat)))

(define-public python2-pytest-pep8
  (package-with-python2 python-pytest-pep8))

(define-public python-pytest-flakes
  (package
    (name "python-pytest-flakes")
    (version "1.0.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "pytest-flakes" version))
              (sha256
               (base32
                "0flag3n33kbhyjrhzmq990rvg4yb8hhhl0i48q9hw0ll89jp28lw"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'check)
         (add-after 'install 'check
           (lambda* (#:key outputs inputs #:allow-other-keys)
             ;; It's easier to run tests after install.
             ;; Make installed package available for running the tests
             (add-installed-pythonpath inputs outputs)
             (zero? (system* "py.test" "-vv")))))))
    (native-inputs
     `(("python-coverage" ,python-coverage)
       ("python-pytest" ,python-pytest)
       ("python-pytest-cache" ,python-pytest-cache)
       ("python-pytest-pep8" ,python-pytest-pep8)))
    (propagated-inputs
     `(("python-pyflakes" ,python-pyflakes)))
    (home-page "https://github.com/fschulze/pytest-flakes")
    (synopsis "Py.test plugin to check source code with pyflakes")
    (description "Pytest plugin for checking Python source code with pyflakes.")
    (license license:expat)))

(define-public python2-pytest-flakes
  (package-with-python2 python-pytest-flakes))

(define-public python2-coverage-test-runner
  (package
    (name "python2-coverage-test-runner")
    (version "1.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://git.liw.fi/cgi-bin/cgit/cgit.cgi/"
             "coverage-test-runner/snapshot/coverage-test-runner-"
             version ".tar.gz"))
       (sha256
        (base32
         "0y1m7z3dl63kmhcmydl1mwg0hacnf6ghrx9dah17j9iasssfa3g7"))))
    (build-system python-build-system)
    (arguments
     `(#:python ,python-2
       #:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (zero? (system* "./testrun")))))))
    (propagated-inputs
     `(("python2-coverage" ,python2-coverage)))
    (home-page "https://liw.fi/coverage-test-runner/")
    (synopsis "Python module for running unit tests")
    (description "@code{CoverageTestRunner} is a python module for running
unit tests and failing them if the unit test module does not exercise all
statements in the module it tests.")
    (license license:gpl3+)))

(define-public python-pylint
  (package
    (name "python-pylint")
    (version "1.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/PyCQA/pylint/archive/pylint-"
             version ".tar.gz"))
       (sha256
        (base32
         "0mzn1czhf1mgr2wiqfihb274sja02h899b85kywdpivppa9nwrmp"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-pytest-runner" ,python-pytest-runner)
       ("python-tox" ,python-tox)))
    (propagated-inputs
     `(("python-astroid" ,python-astroid)
       ("python-isort" ,python-isort)
       ("python-mccabe" ,python-mccabe)
       ("python-six" ,python-six)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
                  (lambda _
                    ;; Somehow, tests for python2-pylint
                    ;; fail if run from the build directory
                    (let ((work "/tmp/work"))
                      (mkdir-p work)
                      (setenv "PYTHONPATH"
                              (string-append (getenv "PYTHONPATH") ":" work))
                      (copy-recursively "." work)
                      (with-directory-excursion "/tmp"
                        (zero? (system* "python" "-m" "unittest" "discover"
                                        "-s" (string-append work "/pylint/test")
                                        "-p" "*test_*.py")))))))))
    (home-page "https://github.com/PyCQA/pylint")
    (synopsis "Python source code analyzer which looks for coding standard
errors")
    (description "Pylint is a Python source code analyzer which looks
for programming errors, helps enforcing a coding standard and sniffs
for some code smells (as defined in Martin Fowler's Refactoring book).

Pylint has many rules enabled by default, way too much to silence them
all on a minimally sized program.  It's highly configurable and handle
pragmas to control it from within your code.  Additionally, it is
possible to write plugins to add your own checks.")
    (properties `((python2-variant . ,(delay python2-pylint))))
    (license license:gpl2+)))

(define-public python2-pylint
  (let ((pylint (package-with-python2
                  (strip-python2-variant python-pylint))))
    (package (inherit pylint)
             (propagated-inputs
              `(("python2-backports-functools-lru-cache"
                 ,python2-backports-functools-lru-cache)
                ("python2-configparser" ,python2-configparser)
                ,@(package-propagated-inputs pylint))))))

(define-public python-paramunittest
  (package
    (name "python-paramunittest")
    (version "0.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ParamUnittest" version))
       (sha256
        (base32
         "0kp793hws5xv1wvycxq7jw2pwy36f35k39jg8hx5qikij5a0jid1"))))
    (build-system python-build-system)
    (home-page
     "https://github.com/rik0/ParamUnittest")
    (synopsis
     "Simple extension to have parametrized unit tests")
    (description
     "This package allows to create parametrized unit-tests that work with the standard
unittest package.  A parametrized test case is automatically converted to multiple test
cases.  Since they are TestCase subclasses, they work with other test suites that
recognize TestCases.")
    (license license:bsd-2)))

(define-public python2-python-paramunittest
  (package-with-python2 python-paramunittest))

(define-public python-pytest-warnings
  (package
    (name "python-pytest-warnings")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-warnings" version))
       (sha256
        (base32
         "0gf2dpahpl5igb7jh1sr9acj3z3gp7zahqdqb69nk6wx01c8kc1g"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("pytest" ,python-pytest)))
    (home-page "https://github.com/fschulze/pytest-warnings")
    (synopsis "Pytest plugin to list Python warnings in pytest report")
    (description
     "Python-pytest-warnings is a pytest plugin to list Python warnings in
pytest report.")
    (license license:expat)
    (properties `((python2-variant . ,(delay python2-pytest-warnings))
                  ;; This package is part of pytest as of version 3.1.0.
                  (superseded . ,python-pytest)))))

(define-public python2-pytest-warnings
  (package (inherit (package-with-python2
                     (strip-python2-variant python-pytest-warnings)))
           (properties `((superseded . ,python2-pytest)))))

(define-public python-pytest-capturelog
  (package
    (name "python-pytest-capturelog")
    (version "0.7")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-capturelog" version ".tar.gz"))
       (sha256
        (base32
         "038049nyjl7di59ycnxvc9nydivc5m8np3hqq84j2iirkccdbs5n"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("pytest" ,python-pytest)))
    (home-page "https://bitbucket.org/memedough/pytest-capturelog/overview")
    (synopsis "Pytest plugin to catch log messages")
    (description
     "Python-pytest-catchlog is a pytest plugin to catch log messages.")
    (license license:expat)))

(define-public python2-pytest-capturelog
  (package-with-python2 python-pytest-capturelog))

(define-public python-pytest-catchlog
  (package
    (name "python-pytest-catchlog")
    (version "1.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-catchlog" version ".zip"))
       (sha256
        (base32
         "1w7wxh27sbqwm4jgwrjr9c2gy384aca5jzw9c0wzhl0pmk2mvqab"))))
    (build-system python-build-system)
    (native-inputs
     `(("unzip" ,unzip)))
    (propagated-inputs
     `(("pytest" ,python-pytest)))
    (home-page "https://github.com/eisensheng/pytest-catchlog")
    (synopsis "Pytest plugin to catch log messages")
    (description
     "Python-pytest-catchlog is a pytest plugin to catch log messages.  This is
a fork of pytest-capturelog.")
    (license license:expat)))

(define-public python2-pytest-catchlog
  (package-with-python2 python-pytest-catchlog))

(define-public python-nosexcover
  (package
    (name "python-nosexcover")
    (version "1.0.11")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "nosexcover" version))
              (sha256
               (base32
                "10xqr12qv62k2flxwqhh8cr00cjhn7sfjrm6p35gd1x5bmjkr319"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-coverage" ,python-coverage)
       ("python-nose" ,python-nose)))
    (home-page "http://github.com/cmheisel/nose-xcover")
    (synopsis "Extends nose.plugins.cover to add Cobertura-style XML reports")
    (description "Nose-xcover is a companion to the built-in
@code{nose.plugins.cover}.  This plugin will write out an XML coverage report
to a file named coverage.xml.

It will honor all the options you pass to the Nose coverage plugin,
especially -cover-package.")
    (license license:expat)))

(define-public python2-nosexcover
  (package-with-python2 python-nosexcover))

(define-public python-discover
  (package
    (name "python-discover")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://pypi.python.org/packages/source/d/discover/discover-"
             version ".tar.gz"))
       (sha256
        (base32
         "0y8d0zwiqar51kxj8lzmkvwc3b8kazb04gk5zcb4nzg5k68zmhq5"))))
    (build-system python-build-system)
    (home-page "http://pypi.python.org/pypi/discover/")
    (synopsis
     "Python test discovery for unittest")
    (description
     "Discover provides test discovery for unittest, a feature that has been
backported from Python 2.7 for Python 2.4+.")
    (license license:bsd-3)))

(define-public python2-discover
  (package-with-python2 python-discover))

(define-public behave
  (package
    (name "behave")
    (version "1.2.6")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "behave" version))
             (sha256
              (base32
               "11hsz365qglvpp1m1w16239c3kiw15lw7adha49lqaakm8kj6rmr"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-mock" ,python-mock)
       ("python-nose" ,python-nose)
       ("python-pathpy" ,python-pathpy)
       ("python-pyhamcrest" ,python-pyhamcrest)
       ("python-pytest" ,python-pytest)))
    (propagated-inputs
     `(("python-six" ,python-six)
       ("python-parse" ,python-parse)
       ("python-parse-type" ,python-parse-type)))
    (arguments
     '(#:test-target "behave_test"))
    (home-page "https://github.com/behave/behave")
    (synopsis "Python behavior-driven development")
    (description
     "Behave is a tool for behavior-driven development in python.
Behavior-driven development (or BDD) is an agile software development
technique that encourages collaboration between developers, QA and
non-technical or business participants in a software project.  Behave uses
tests written in a natural language style, backed up by Python code.")
    (license license:x11)))

(define-public python-behave-web-api
  (package
    (name "python-behave-web-api")
    (version "1.0.6")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "behave-web-api" version))
       (sha256
        (base32
         "03kpq2xsy1gab3jy0dccbxlsg7vwfy4lagss0qldwmx3xz6b3i19"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-dependencies
           (lambda _
             (substitute* "setup.py"
               (("'wheel'") "")                ; We don't use it.
               (("'ordereddict==1.1'") ""))))))) ; Python >= 2.7 has it built-in.
    (propagated-inputs
     `(("behave" ,behave)
       ("python-requests" ,python-requests)))
    (home-page "https://github.com/jefersondaniel/behave-web-api")
    (synopsis "Provides testing for JSON APIs with Behave for Python")
    (description "This package provides testing utility modules for testing
JSON APIs with Behave.")
    (license license:expat)))

(define-public python2-behave-web-api
  (package-with-python2 python-behave-web-api))

(define-public python-rednose
  (package
    (name "python-rednose")
    (version "1.2.3")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rednose" version))
        (sha256
          (base32
            "11x5nx5b4wdq04s7vj1gcdl07jvvkfb37p0r5lg773gr5rr8mj6h"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-after 'unpack 'patch-setup.py
                    (lambda _
                      ;; Six is only required for tests and later versions
                      ;; work fine.
                      (substitute* "setup.py"
                        (("six==1.10.0") "six"))
                      #t)))))
    (propagated-inputs
     `(("python-colorama" ,python-colorama)
       ("python-termstyle" ,python-termstyle)))
    (native-inputs
     `(("python-six" ,python-six)
       ("python-nose" ,python-nose)))
    (home-page "https://github.com/JBKahn/rednose")
    (synopsis "Colored output for Python nosetests")
    (description "This package provides colored output for the
@command{nosetests} command of the Python Nose unit test framework.")
    (license license:bsd-3)))

(define-public python2-rednose
  (package-with-python2 python-rednose))

(define-public python-nose-randomly
  (package
    (name "python-nose-randomly")
    (version "1.2.5")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "nose-randomly" version))
       (sha256
        (base32
         "1cw9dlr1zh3w4i438kin7z0rm8092ki52hayisyc43h9pcplq7rn"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)
       ("python-numpy" ,python-numpy)))
    (home-page "https://github.com/adamchainz/nose-randomly")
    (synopsis
     "Nose plugin to randomly order tests and control random.seed")
    (description
     "This is a @code{Nose} plugin to randomly order tests which can be quite
powerful in discovering hidden flaws in the tests themselves, while helping to
reduce inter-test dependencies.  It also helps in controlling @code{random.seed},
by resetting it to a repeatable number for each test, enabling the tests to
create data based on random numbers and yet remain repeatable.")
    (license license:bsd-3)))

(define-public python2-nose-randomly
  (package-with-python2 python-nose-randomly))

(define-public python-nose-timer
  (package
    (name "python-nose-timer")
    (version "0.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "nose-timer" version))
        (patches
         (search-patches
          ;; This patch will not be needed in the next version.
          ;; It is taken from the master branch.
          "python-nose-timer-drop-ordereddict.patch"))
        (sha256
          (base32
            "1s32ymsnby8lz2qk55ifj9zi50dqcg6swnj5cz2rmwxg2jsslsxp"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-nose" ,python-nose)
       ("python-termcolor" ,python-termcolor)))
    (home-page "https://github.com/mahmoudimus/nose-timer")
    (synopsis "Timer plugin for nosetests")
    (description "Shows how much time was needed to run individual tests.")
    (license license:expat)))

(define-public python2-nose-timer
  (package-with-python2 python-nose-timer))

(define-public python-freezegun
  (package
    (name "python-freezegun")
    (version "0.3.9")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "freezegun" version))
       (sha256
        (base32
         "1vhf3kgdy7gpy70n3bxa3y1n6aza316137md97z8p5k0gz6wqg3q"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-mock" ,python-mock)
       ("python-nose" ,python-nose)
       ("python-coverage" ,python-coverage)))
    (propagated-inputs
     `(("python-six" ,python-six)
       ("python-dateutil" ,python-dateutil)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; The tests are normally executed via `make test`, but the PyPi
         ;; package does not include the Makefile.
         (replace 'check
           (lambda _
             (zero? (system* "nosetests" "./tests/")))))))
    (home-page "https://github.com/spulec/freezegun")
    (synopsis "Test utility for mocking the datetime module")
    (description
     "FreezeGun is a library that allows your python tests to travel through
time by mocking the datetime module.")
    (license license:asl2.0)))

(define-public python2-freezegun
  (package-with-python2 python-freezegun))

(define-public python-flexmock
  (package
    (name "python-flexmock")
    (version "0.10.2")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "flexmock" version))
              (sha256
               (base32
                "0arc6njvs6i9v9hgvzk5m50296g7zy5m9d7pyb43vdsdgxrci5gy"))))
    (build-system python-build-system)
    (home-page "https://flexmock.readthedocs.org")
    (synopsis "Testing library for Python")
    (description
     "flexmock is a testing library for Python that makes it easy to create
mocks, stubs and fakes.")
    (license license:bsd-3)))

(define-public python2-flexmock
  (package-with-python2 python-flexmock))

(define-public python-flaky
  (package
    (name "python-flaky")
    (version "3.4.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "flaky" version))
              (sha256
               (base32
                "18pkmf79rfkfpy1d2rrx3v55nxj762ilyk9rvd6s6dccxw58imsa"))))
    (build-system python-build-system)
    (arguments
     ;; TODO: Tests require 'coveralls' and 'genty' which are not in Guix yet.
     '(#:tests? #f))
    (home-page "https://github.com/box/flaky")
    (synopsis "Automatically rerun flaky tests")
    (description
     "Flaky is a plugin for @code{nose} or @code{py.test} that automatically
reruns flaky tests.

Ideally, tests reliably pass or fail, but sometimes test fixtures must rely
on components that aren't 100% reliable.  With flaky, instead of removing
those tests or marking them to @code{@@skip}, they can be automatically
retried.")
    (license license:asl2.0)))

(define-public python2-flaky
  (package-with-python2 python-flaky))

(define-public python-pyhamcrest
  (package
    (name "python-pyhamcrest")
    (version "1.9.0")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "https://github.com/hamcrest/PyHamcrest/archive/V"
                version
                ".tar.gz"))
              (file-name
               (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1lqjajhwf7x7igvvnj5p1cm31y9njy07qby94w18kl6zwbdjqrwy"))))
    (native-inputs                      ; All native inputs are for tests
     `(("python-pytest-cov" ,python-pytest-cov)
       ("python-mock" ,python-mock)
       ("python-pytest" ,python-pytest)
       ("python-hypothesis" ,python-hypothesis)))
    (propagated-inputs
     `(("python-six" ,python-six)))
    (build-system python-build-system)
    (home-page "http://hamcrest.org/")
    (synopsis "Hamcrest matchers for Python")
    (description
     "PyHamcrest is a framework for writing matcher objects,
 allowing you to declaratively define \"match\" rules.")
    (license license:bsd-3)))

(define-public python2-pyhamcrest
  (package-with-python2 python-pyhamcrest))

(define-public unittest-cpp
  (package
    (name "unittest-cpp")
    (version "2.0.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/unittest-cpp/unittest-cpp/archive/v"
                    version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32 "1fgmna2la7z4pwwy2gd10gpgi2q1fk89npjfvkmzvhkxhyc231bl"))))
    (arguments
     `(#:tests? #f))                     ; It's run after build automatically.
    (build-system cmake-build-system)
    (home-page "https://github.com/unittest-cpp/unittest-cpp")
    (synopsis "Lightweight unit testing framework for C++")
    (description "UnitTest++ is a lightweight unit testing framework for C++.
It was designed to do test-driven development on a wide variety of platforms.
Simplicity, portability, speed, and small footprint are all very important
aspects of UnitTest++.  UnitTest++ is mostly standard C++ and makes minimal use
of advanced library and language features, which means it should be easily
portable to just about any platform.")
    (license license:expat)))
