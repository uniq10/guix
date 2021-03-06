;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2018 Chris Marusich <cmmarusich@gmail.com>
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

(define-module (guix docker)
  #:use-module (guix hash)
  #:use-module (guix base16)
  #:use-module ((guix build utils)
                #:select (mkdir-p
                          delete-file-recursively
                          with-directory-excursion
                          invoke))
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:use-module ((texinfo string-utils)
                #:select (escape-special-chars))
  #:use-module (rnrs bytevectors)
  #:use-module (ice-9 match)
  #:export (build-docker-image))

;; Load Guile-JSON at run time to simplify the job of 'imported-modules' & co.
(module-use! (current-module) (resolve-interface '(json)))

;; Generate a 256-bit identifier in hexadecimal encoding for the Docker image.
(define docker-id
  (compose bytevector->base16-string sha256 string->utf8))

(define (layer-diff-id layer)
  "Generate a layer DiffID for the given LAYER archive."
  (string-append "sha256:" (bytevector->base16-string (file-sha256 layer))))

;; This is the semantic version of the JSON metadata schema according to
;; https://github.com/docker/docker/blob/master/image/spec/v1.2.md
;; It is NOT the version of the image specification.
(define schema-version "1.0")

(define (image-description id time)
  "Generate a simple image description."
  `((id . ,id)
    (created . ,time)
    (container_config . #nil)))

(define (generate-tag path)
  "Generate an image tag for the given PATH."
  (match (string-split (basename path) #\-)
    ((hash name . rest) (string-append name ":" hash))))

(define (manifest path id)
  "Generate a simple image manifest."
  `(((Config . "config.json")
     (RepoTags . (,(generate-tag path)))
     (Layers . (,(string-append id "/layer.tar"))))))

;; According to the specifications this is required for backwards
;; compatibility.  It duplicates information provided by the manifest.
(define (repositories path id)
  "Generate a repositories file referencing PATH and the image ID."
  `((,(generate-tag path) . ((latest . ,id)))))

;; See https://github.com/opencontainers/image-spec/blob/master/config.md
(define (config layer time arch)
  "Generate a minimal image configuration for the given LAYER file."
  ;; "architecture" must be values matching "platform.arch" in the
  ;; runtime-spec at
  ;; https://github.com/opencontainers/runtime-spec/blob/v1.0.0-rc2/config.md#platform
  `((architecture . ,arch)
    (comment . "Generated by GNU Guix")
    (created . ,time)
    (config . #nil)
    (container_config . #nil)
    (os . "linux")
    (rootfs . ((type . "layers")
               (diff_ids . (,(layer-diff-id layer)))))))

(define %tar-determinism-options
  ;; GNU tar options to produce archives deterministically.
  '("--sort=name" "--mtime=@1"
    "--owner=root:0" "--group=root:0"))

(define symlink-source
  (match-lambda
    ((source '-> target)
     (string-trim source #\/))))

(define (topmost-component file)
  "Return the topmost component of FILE.  For instance, if FILE is \"/a/b/c\",
return \"a\"."
  (match (string-tokenize file (char-set-complement (char-set #\/)))
    ((first rest ...)
     first)))

(define* (build-docker-image image paths prefix
                             #:key
                             (symlinks '())
                             (transformations '())
                             (system (utsname:machine (uname)))
                             compressor
                             (creation-time (current-time time-utc)))
  "Write to IMAGE a Docker image archive containing the given PATHS.  PREFIX
must be a store path that is a prefix of any store paths in PATHS.

SYMLINKS must be a list of (SOURCE -> TARGET) tuples describing symlinks to be
created in the image, where each TARGET is relative to PREFIX.
TRANSFORMATIONS must be a list of (OLD -> NEW) tuples describing how to
transform the PATHS.  Any path in PATHS that begins with OLD will be rewritten
in the Docker image so that it begins with NEW instead.  If a path is a
non-empty directory, then its contents will be recursively added, as well.

SYSTEM is a GNU triplet (or prefix thereof) of the system the binaries in
PATHS are for; it is used to produce metadata in the image.  Use COMPRESSOR, a
command such as '(\"gzip\" \"-9n\"), to compress IMAGE.  Use CREATION-TIME, a
SRFI-19 time-utc object, as the creation time in metadata."
  (define (sanitize path-fragment)
    (escape-special-chars
     ;; GNU tar strips the leading slash off of absolute paths before applying
     ;; the transformations, so we need to do the same, or else our
     ;; replacements won't match any paths.
     (string-trim path-fragment #\/)
     ;; Escape the basic regexp special characters (see: "(sed) BRE syntax").
     ;; We also need to escape "/" because we use it as a delimiter.
     "/*.^$[]\\"
     #\\))
  (define transformation->replacement
    (match-lambda
      ((old '-> new)
       ;; See "(tar) transform" for details on the expression syntax.
       (string-append "s/^" (sanitize old) "/" (sanitize new) "/"))))
  (define (transformations->expression transformations)
    (let ((replacements (map transformation->replacement transformations)))
      (string-append
       ;; Avoid transforming link targets, since that would break some links
       ;; (e.g., symlinks that point to an absolute store path).
       "flags=rSH;"
       (string-join replacements ";")
       ;; Some paths might still have a leading path delimiter even after tar
       ;; transforms them (e.g., "/a/b" might be transformed into "/b"), so
       ;; strip any leading path delimiters that remain.
       ";s,^//*,,")))
  (define transformation-options
    (if (eq? '() transformations)
        '()
        `("--transform" ,(transformations->expression transformations))))
  (let* ((directory "/tmp/docker-image") ;temporary working directory
         (id (docker-id prefix))
         (time (date->string (time-utc->date creation-time) "~4"))
         (arch (let-syntax ((cond* (syntax-rules ()
                                     ((_ (pattern clause) ...)
                                      (cond ((string-prefix? pattern system)
                                             clause)
                                            ...
                                            (else
                                             (error "unsupported system"
                                                    system)))))))
                 (cond* ("x86_64" "amd64")
                        ("i686"   "386")
                        ("arm"    "arm")
                        ("mips64" "mips64le")))))
    ;; Make sure we start with a fresh, empty working directory.
    (mkdir directory)
    (with-directory-excursion directory
      (mkdir id)
      (with-directory-excursion id
        (with-output-to-file "VERSION"
          (lambda () (display schema-version)))
        (with-output-to-file "json"
          (lambda () (scm->json (image-description id time))))

        ;; Create SYMLINKS.
        (for-each (match-lambda
                    ((source '-> target)
                     (let ((source (string-trim source #\/)))
                       (mkdir-p (dirname source))
                       (symlink (string-append prefix "/" target)
                                source))))
                  symlinks)

        (apply invoke "tar" "-cf" "layer.tar"
               `(,@transformation-options
                 ,@%tar-determinism-options
                 ,@paths
                 ,@(map symlink-source symlinks)))
        ;; It is possible for "/" to show up in the archive, especially when
        ;; applying transformations.  For example, the transformation
        ;; "s,^/a,," will (perhaps surprisingly) cause GNU tar to transform
        ;; the path "/a" into "/".  The presence of "/" in the archive is
        ;; probably benign, but it is definitely safe to remove it, so let's
        ;; do that.  This fails when "/" is not in the archive, so use system*
        ;; instead of invoke to avoid an exception in that case.
        (system* "tar" "--delete" "/" "-f" "layer.tar")
        (for-each delete-file-recursively
                  (map (compose topmost-component symlink-source)
                       symlinks)))

      (with-output-to-file "config.json"
        (lambda ()
          (scm->json (config (string-append id "/layer.tar")
                             time arch))))
      (with-output-to-file "manifest.json"
        (lambda ()
          (scm->json (manifest prefix id))))
      (with-output-to-file "repositories"
        (lambda ()
          (scm->json (repositories prefix id)))))

    (apply invoke "tar" "-cf" image "-C" directory
           `(,@%tar-determinism-options
             ,@(if compressor
                   (list "-I" (string-join compressor))
                   '())
             "."))
    (delete-file-recursively directory)))
