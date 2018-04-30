;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016, 2017 Tobias Geerinckx-Rice <me@tobias.gr>
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

(define-module (gnu packages datastructures)
  #:use-module (gnu packages)
  #:use-module (gnu packages perl)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public gdsl
  (package
    (name "gdsl")
    (version "1.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://download.gna.org/gdsl/"
                                  "gdsl-" version ".tar.gz"))
              (sha256
               (base32
                "1v64jvlnj8jfpphphgjgb36p0kv50kwfyqncf0y12f16v8ydyiaw"))))
    (build-system gnu-build-system)
    (home-page "http://home.gna.org/gdsl/")
    (synopsis "Generic data structures library")
    (description "The Generic Data Structures Library (GDSL) is a collection
of routines for generic data structures manipulation.  It is a re-entrant
library fully written from scratch in pure ANSI C.  It is designed to offer
for C programmers common data structures with powerful algorithms, and hidden
implementation.  Available structures are lists, queues, stacks, hash tables,
binary trees, binary search trees, red-black trees, 2D arrays, permutations
and heaps.")
    (license license:gpl2+)))

(define-public sparsehash
  (package
    (name "sparsehash")
    (version "2.0.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/sparsehash/sparsehash/"
                                  "archive/sparsehash-" version ".tar.gz"))
              (sha256
               (base32
                "133szz0ldwch0kd91l0sa57qsnl020njn622szd9cxrjqyjqds85"))))
    (build-system gnu-build-system)
    (synopsis "Memory-efficient hashtable implementations")
    (description
     "This library contains several hash-map implementations, similar in API
to SGI's @code{hash_map} class, but with different performance
characteristics.  @code{sparse_hash_map} uses very little space overhead, 1-2
bits per entry.  @code{dense_hash_map} is very fast, particularly on lookup.
@code{sparse_hash_set} and @code{dense_hash_set} are the set versions of these
routines.  All these implementation use a hashtable with internal quadratic
probing.  This method is space-efficient -- there is no pointer overhead --
and time-efficient for good hash functions.")
    (home-page "https://github.com/sparsehash/sparsehash")
    (license license:bsd-3)))

(define-public ssdeep
  (package
    (name "ssdeep")
    (version "2.13")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/ssdeep/"
                                  name "-" version "/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "1igqy0j7jrklb8fdlrm6ald4cyl1fda5ipfl8crzyl6bax2ajk3f"))))
    (build-system gnu-build-system)
    (home-page "http://ssdeep.sourceforge.net")
    (synopsis "Context-triggered piecewise hashing algorithm")
    (description "ssdeep computes and matches context triggered piecewise
hashes (CTPH), also called fuzzy checksums.  It can identify similar files
that have sequences of identical bytes in the same order, even though bytes
in between these sequences may be different in both content and length.")
    (license license:gpl2+)))

(define-public liburcu
  (package
    (name "liburcu")
    (version "0.10.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.lttng.org/files/urcu/"
                                  "userspace-rcu-" version ".tar.bz2"))
              (sha256
               (base32
                "01pbg67qy5hcssy2yi0ckqapzfclgdq93li2rmzw4pa3wh5j42cw"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("perl" ,perl)))                 ; for tests
    (home-page "http://liburcu.org/")
    (synopsis "User-space RCU data synchronisation library")
    (description "liburcu is a user-space @dfn{Read-Copy-Update} (RCU) data
synchronisation library.  It provides read-side access that scales linearly
with the number of cores.  liburcu-cds provides efficient data structures
based on RCU and lock-free algorithms.  These structures include hash tables,
queues, stacks, and doubly-linked lists.")
    (license license:lgpl2.1+)))

(define-public uthash
  (package
    (name "uthash")
    (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (file-name (string-append name "-" version ".tar.gz"))
       (uri (string-append "https://github.com/troydhanson/uthash/archive/v"
                           version ".tar.gz"))
       (sha256
        (base32
         "1la82gdlyl7m8ahdjirigwfh7zjgkc24cvydrqcri0vsvm8iv8rl"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("perl" ,perl)))
    (arguments
     `(#:make-flags
       (list "CC=gcc")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; nothing to configure
         (delete 'build)                ; nothing to build
         (replace 'check
           (lambda* (#:key make-flags #:allow-other-keys)
             (with-directory-excursion "tests"
               (zero? (apply system* "make"
                             make-flags)))))
         (replace 'install
           ;; There is no top-level Makefile to do this for us.
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (doc (string-append out "/share/doc/" ,name))
                    (include (string-append out "/include")))
               ;; Don't install HTML files: they're just the below .txt files
               ;; dolled up, can be stale, and regeneration requires asciidoc.
               (for-each (λ (file) (install-file file doc))
                         (find-files "doc" "\\.txt$"))
               (for-each (λ (file) (install-file file include))
                         (find-files "src" "\\.h$"))
               #t))))))
    (home-page "https://troydhanson.github.io/uthash/")
    (synopsis
     "Hash tables, lists, and other data structures implemented as C macros")
    (description
     "uthash implements a hash table and a few other basic data structures
as C preprocessor macros.  It aims to be minimalistic and efficient: it's
around 1,000 lines of code which, being macros, inline automatically.

Unlike function calls with fixed prototypes, macros operate on untyped
arguments.  Thus, they are able to work with any type of structure and key.
Any C structure can be stored in a hash table by adding @code{UT_hash_handle}
to the structure and choosing one or more fields to act as the key.")
    (license license:bsd-2)))
