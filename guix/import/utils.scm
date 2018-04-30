;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2018 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016 Jelle Licht <jlicht@fsfe.org>
;;; Copyright © 2016 David Craven <david@craven.ch>
;;; Copyright © 2017 Ricardo Wurmus <rekado@elephly.net>
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

(define-module (guix import utils)
  #:use-module (guix base32)
  #:use-module ((guix build download) #:prefix build:)
  #:use-module (guix hash)
  #:use-module (guix http-client)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix discovery)
  #:use-module (guix build-system)
  #:use-module (guix gexp)
  #:use-module (guix store)
  #:use-module (guix download)
  #:use-module (gnu packages)
  #:use-module (ice-9 match)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 receive)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:export (factorize-uri

            hash-table->alist
            flatten
            assoc-ref*

            url-fetch
            guix-hash-url

            maybe-inputs
            maybe-native-inputs
            package->definition

            spdx-string->license
            license->symbol

            snake-case
            beautify-description

            alist->package

            read-lines
            chunk-lines))

(define (factorize-uri uri version)
  "Factorize URI, a package tarball URI as a string, such that any occurrences
of the string VERSION is replaced by the symbol 'version."
  (let ((version-rx (make-regexp (regexp-quote version))))
    (match (regexp-exec version-rx uri)
      (#f
       uri)
      (_
       (let ((indices (fold-matches version-rx uri
                                    '((0))
                                    (lambda (m result)
                                      (match result
                                        (((start) rest ...)
                                         `((,(match:end m))
                                           (,start . ,(match:start m))
                                           ,@rest)))))))
         (fold (lambda (index result)
                 (match index
                   ((start)
                    (cons (substring uri start)
                          result))
                   ((start . end)
                    (cons* (substring uri start end)
                           'version
                           result))))
               '()
               indices))))))

(define (hash-table->alist table)
  "Return an alist represenation of TABLE."
  (map (match-lambda
        ((key . (lst ...))
         (cons key
               (map (lambda (x)
                      (if (hash-table? x)
                          (hash-table->alist x)
                          x))
                    lst)))
        ((key . (? hash-table? table))
         (cons key (hash-table->alist table)))
        (pair pair))
       (hash-map->list cons table)))

(define (flatten lst)
  "Return a list that recursively concatenates all sub-lists of LST."
  (fold-right
   (match-lambda*
    (((sub-list ...) memo)
     (append (flatten sub-list) memo))
    ((elem memo)
     (cons elem memo)))
   '() lst))

(define (assoc-ref* alist key . rest)
  "Return the value for KEY from ALIST.  For each additional key specified,
recursively apply the procedure to the sub-list."
  (if (null? rest)
      (assoc-ref alist key)
      (apply assoc-ref* (assoc-ref alist key) rest)))

(define (url-fetch url file-name)
  "Save the contents of URL to FILE-NAME.  Return #f on failure."
  (parameterize ((current-output-port (current-error-port)))
    (build:url-fetch url file-name)))

(define (guix-hash-url filename)
  "Return the hash of FILENAME in nix-base32 format."
  (bytevector->nix-base32-string (file-sha256 filename)))

(define (spdx-string->license str)
  "Convert STR, a SPDX formatted license identifier, to a license object.
   Return #f if STR does not match any known identifiers."
  ;; https://spdx.org/licenses/
  ;; The psfl, gfl1.0, nmap, repoze
  ;; licenses doesn't have SPDX identifiers
  (match str
    ("AGPL-1.0"                    'license:agpl-1.0)
    ("AGPL-3.0"                    'license:agpl-3.0)
    ("Apache-1.1"                  'license:asl1.1)
    ("Apache-2.0"                  'license:asl2.0)
    ("BSL-1.0"                     'license:boost1.0)
    ("BSD-2-Clause-FreeBSD"        'license:bsd-2)
    ("BSD-3-Clause"                'license:bsd-3)
    ("BSD-4-Clause"                'license:bsd-4)
    ("CC0-1.0"                     'license:cc0)
    ("CC-BY-2.0"                   'license:cc-by2.0)
    ("CC-BY-3.0"                   'license:cc-by3.0)
    ("CC-BY-SA-2.0"                'license:cc-by-sa2.0)
    ("CC-BY-SA-3.0"                'license:cc-by-sa3.0)
    ("CC-BY-SA-4.0"                'license:cc-by-sa4.0)
    ("CDDL-1.0"                    'license:cddl1.0)
    ("CECILL-C"                    'license:cecill-c)
    ("Artistic-2.0"                'license:artistic2.0)
    ("ClArtistic"                  'license:clarified-artistic)
    ("CPL-1.0"                     'license:cpl1.0)
    ("EPL-1.0"                     'license:epl1.0)
    ("MIT"                         'license:expat)
    ("FTL"                         'license:freetype)
    ("GFDL-1.1"                    'license:fdl1.1+)
    ("GFDL-1.2"                    'license:fdl1.2+)
    ("GFDL-1.3"                    'license:fdl1.3+)
    ("Giftware"                    'license:giftware)
    ("GPL-1.0"                     'license:gpl1)
    ("GPL-1.0+"                    'license:gpl1+)
    ("GPL-2.0"                     'license:gpl2)
    ("GPL-2.0+"                    'license:gpl2+)
    ("GPL-3.0"                     'license:gpl3)
    ("GPL-3.0+"                    'license:gpl3+)
    ("ISC"                         'license:isc)
    ("IJG"                         'license:ijg)
    ("Imlib2"                      'license:imlib2)
    ("IPA"                         'license:ipa)
    ("IPL-1.0"                     'license:ibmpl1.0)
    ("LGPL-2.0"                    'license:lgpl2.0)
    ("LGPL-2.0+"                   'license:lgpl2.0+)
    ("LGPL-2.1"                    'license:lgpl2.1)
    ("LGPL-2.1+"                   'license:lgpl2.1+)
    ("LGPL-3.0"                    'license:lgpl3.0)
    ("LGPL-3.0+"                   'license:lgpl3.0+)
    ("MPL-1.0"                     'license:mpl1.0)
    ("MPL-1.1"                     'license:mpl1.1)
    ("MPL-2.0"                     'license:mpl2.0)
    ("MS-PL"                       'license:ms-pl)
    ("NCSA"                        'license:ncsa)
    ("OpenSSL"                     'license:openssl)
    ("OLDAP-2.8"                   'license:openldap2.8)
    ("CUA-OPL-1.0"                 'license:opl1.0)
    ("QPL-1.0"                     'license:qpl)
    ("Ruby"                        'license:ruby)
    ("SGI-B-2.0"                   'license:sgifreeb2.0)
    ("OFL-1.1"                     'license:silofl1.1)
    ("Sleepycat"                   'license:sleepycat)
    ("TCL"                         'license:tcl/tk)
    ("Unlicense"                   'license:unlicense)
    ("Vim"                         'license:vim)
    ("X11"                         'license:x11)
    ("ZPL-2.1"                     'license:zpl2.1)
    ("Zlib"                        'license:zlib)
    (_ #f)))

(define (license->symbol license)
  "Convert license to a symbol representing the variable the object is bound
to in the (guix licenses) module, or #f if there is no such known license."
  (define licenses
    (module-map (lambda (sym var) `(,(variable-ref var) . ,sym))
                (resolve-interface '(guix licenses) #:prefix 'license:)))
  (assoc-ref licenses license))

(define (snake-case str)
  "Return a downcased version of the string STR where underscores are replaced
with dashes."
  (string-join (string-split (string-downcase str) #\_) "-"))

(define (beautify-description description)
  "Improve the package DESCRIPTION by turning a beginning sentence fragment
into a proper sentence and by using two spaces between sentences."
  (let ((cleaned (if (string-prefix? "A " description)
                     (string-append "This package provides a"
                                    (substring description 1))
                     description)))
    ;; Use double spacing between sentences
    (regexp-substitute/global #f "\\. \\b"
                              cleaned 'pre ".  " 'post)))

(define* (package-names->package-inputs names #:optional (output #f))
  (map (lambda (input)
         (cons* input (list 'unquote (string->symbol input))
                            (or (and output (list output))
                                '())))
       names))

(define* (maybe-inputs package-names #:optional (output #f))
  "Given a list of PACKAGE-NAMES, tries to generate the 'inputs' field of a
package definition."
  (match (package-names->package-inputs package-names output)
    (()
     '())
    ((package-inputs ...)
     `((inputs (,'quasiquote ,package-inputs))))))

(define* (maybe-native-inputs package-names #:optional (output #f))
  "Given a list of PACKAGE-NAMES, tries to generate the 'inputs' field of a
package definition."
  (match (package-names->package-inputs package-names output)
    (()
     '())
    ((package-inputs ...)
     `((native-inputs (,'quasiquote ,package-inputs))))))

(define (package->definition guix-package)
  (match guix-package
    (('package ('name (? string? name)) _ ...)
     `(define-public ,(string->symbol name)
        ,guix-package))))

(define (build-system-modules)
  (all-modules (map (lambda (entry)
                      `(,entry . "guix/build-system"))
                    %load-path)))

(define (lookup-build-system-by-name name)
  "Return a <build-system> value for the symbol NAME, representing the name of
the build system."
  (fold-module-public-variables (lambda (obj result)
                                  (if (and (build-system? obj)
                                           (eq? name (build-system-name obj)))
                                      obj result))
                                #f
                                (build-system-modules)))

(define (specs->package-lists specs)
  "Convert each string in the SPECS list to a list of a package label and a
package value."
  (map (lambda (spec)
         (let-values (((pkg out) (specification->package+output spec)))
           (match out
             (("out") (list (package-name pkg) pkg))
             (_ (list (package-name pkg) pkg out)))))
       specs))

(define (source-spec->object source)
  "Generate an <origin> object from a SOURCE specification.  The SOURCE can
either be a simple URL string, #F, or an alist containing entries for each of
the expected fields of an <origin> object."
  (match source
    ((? string? source-url)
     (let ((tarball (with-store store (download-to-store store source-url))))
       (origin
         (method url-fetch)
         (uri source-url)
         (sha256 (base32 (guix-hash-url tarball))))))
    (#f #f)
    (orig (let ((sha (match (assoc-ref orig "sha256")
                       ((("base32" . value))
                        (base32 value))
                       (_ #f))))
            (origin
              (method (match (assoc-ref orig "method")
                        ("url-fetch" (@ (guix download) url-fetch))
                        ("git-fetch" (@ (guix git-download) git-fetch))
                        ("svn-fetch" (@ (guix svn-download) svn-fetch))
                        ("hg-fetch"  (@ (guix hg-download) hg-fetch))
                        (_ #f)))
              (uri (assoc-ref orig "uri"))
              (sha256 sha))))))

(define (alist->package meta)
  (package
    (name (assoc-ref meta "name"))
    (version (assoc-ref meta "version"))
    (source (source-spec->object (assoc-ref meta "source")))
    (build-system
      (lookup-build-system-by-name
       (string->symbol (assoc-ref meta "build-system"))))
    (native-inputs
     (specs->package-lists (or (assoc-ref meta "native-inputs") '())))
    (inputs
     (specs->package-lists (or (assoc-ref meta "inputs") '())))
    (propagated-inputs
     (specs->package-lists (or (assoc-ref meta "propagated-inputs") '())))
    (home-page
     (assoc-ref meta "home-page"))
    (synopsis
     (assoc-ref meta "synopsis"))
    (description
     (assoc-ref meta "description"))
    (license
     (match (assoc-ref meta "license")
       (#f #f)
       (l
        (or (module-ref (resolve-interface '(guix licenses) #:prefix 'license:)
                        (spdx-string->license l))
            (license:fsdg-compatible l)))))))

(define* (read-lines #:optional (port (current-input-port)))
  "Read lines from PORT and return them as a list."
  (let loop ((line (read-line port))
             (lines '()))
    (if (eof-object? line)
        (reverse lines)
        (loop (read-line port)
              (cons line lines)))))

(define* (chunk-lines lines #:optional (pred string-null?))
  "Return a list of chunks, each of which is a list of lines.  The chunks are
separated by PRED."
  (let loop ((rest lines)
             (parts '()))
    (receive (before after)
        (break pred rest)
      (let ((res (cons before parts)))
        (if (null? after)
            (reverse res)
            (loop (cdr after) res))))))
