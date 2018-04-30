;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014, 2018 Ludovic Courtès <ludo@gnu.org>
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

(define-module (guix build-system trivial)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix derivations)
  #:use-module (guix packages)
  #:use-module (guix build-system)
  #:use-module (ice-9 match)
  #:export (trivial-build-system))

(define (guile-for-build store guile system)
  (match guile
    ((? package?)
     (package-derivation store guile system #:graft? #f))
    (#f                                         ; the default
     (let* ((distro (resolve-interface '(gnu packages commencement)))
            (guile  (module-ref distro 'guile-final)))
       (package-derivation store guile system #:graft? #f)))))

(define* (lower name
                #:key source inputs native-inputs outputs system target
                guile builder modules allowed-references)
  "Return a bag for NAME."
  (bag
    (name name)
    (system system)
    (target target)
    (host-inputs `(,@(if source
                         `(("source" ,source))
                         '())
                   ,@inputs))
    (build-inputs native-inputs)
    (outputs outputs)
    (build (if target trivial-cross-build trivial-build))
    (arguments `(#:guile ,guile
                 #:builder ,builder
                 #:modules ,modules
                 #:allowed-references ,allowed-references))))

(define* (trivial-build store name inputs
                        #:key
                        outputs guile system builder (modules '())
                        search-paths allowed-references)
  "Run build expression BUILDER, an expression, for SYSTEM.  SOURCE is
ignored."
  (define canonicalize-reference
    (match-lambda
     ((? package? p)
      (derivation->output-path (package-derivation store p system
                                                   #:graft? #f)))
     (((? package? p) output)
      (derivation->output-path (package-derivation store p system
                                                   #:graft? #f)
                               output))
     ((? string? output)
      output)))

  (build-expression->derivation store name builder
                                #:inputs inputs
                                #:system system
                                #:outputs outputs
                                #:modules modules
                                #:allowed-references
                                (and allowed-references
                                     (map canonicalize-reference
                                          allowed-references))
                                #:guile-for-build
                                (guile-for-build store guile system)))

(define* (trivial-cross-build store name
                              #:key
                              target native-drvs target-drvs
                              outputs guile system builder (modules '())
                              search-paths native-search-paths
                              allowed-references)
  "Run build expression BUILDER, an expression, for SYSTEM.  SOURCE is
ignored."
  (define canonicalize-reference
    (match-lambda
     ((? package? p)
      (derivation->output-path (package-cross-derivation store p system)))
     (((? package? p) output)
      (derivation->output-path (package-cross-derivation store p system)
                               output))
     ((? string? output)
      output)))

  (build-expression->derivation store name builder
                                #:inputs (append native-drvs target-drvs)
                                #:system system
                                #:outputs outputs
                                #:modules modules
                                #:allowed-references
                                (and allowed-references
                                     (map canonicalize-reference
                                          allowed-references))
                                #:guile-for-build
                                (guile-for-build store guile system)))

(define trivial-build-system
  (build-system
    (name 'trivial)
    (description
     "Trivial build system, to run arbitrary Scheme build expressions")
    (lower lower)))
