;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Christopher Baines <mail@cbaines.net>
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

(define-module (gnu tests rsync)
  #:use-module (gnu packages rsync)
  #:use-module (gnu tests)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system shadow)
  #:use-module (gnu system vm)
  #:use-module (gnu services)
  #:use-module (gnu services rsync)
  #:use-module (gnu services networking)
  #:use-module (guix gexp)
  #:use-module (guix store)
  #:export (%test-rsync))

(define* (run-rsync-test rsync-os #:optional (rsync-port 873))
  "Run tests in %RSYNC-OS, which has rsync running and listening on
PORT."
  (define os
    (marionette-operating-system
     rsync-os
     #:imported-modules '((gnu services herd)
                          (guix combinators))))

  (define vm
    (virtual-machine
     (operating-system os)
     (port-forwardings '())))

  (define test
    (with-imported-modules '((gnu build marionette))
      #~(begin
          (use-modules (srfi srfi-11) (srfi srfi-64)
                       (gnu build marionette))

          (define marionette
            (make-marionette (list #$vm)))

          (mkdir #$output)
          (chdir #$output)

          (test-begin "rsync")

          ;; Wait for rsync to be up and running.
          (test-eq "service running"
            'running!
            (marionette-eval
             '(begin
                (use-modules (gnu services herd))
                (start-service 'rsync)
                'running!)
             marionette))

          ;; Make sure the PID file is created.
          (test-assert "PID file"
            (marionette-eval
             '(file-exists? "/var/run/rsyncd/rsyncd.pid")
             marionette))

          (test-assert "Test file copied to share"
            (marionette-eval
             '(begin
                (call-with-output-file "/tmp/input"
                  (lambda (port)
                    (display "test-file-contents\n" port)))
                (zero?
                 (system* "rsync" "/tmp/input"
                          (string-append "rsync://localhost:"
                                         (number->string #$rsync-port)
                                         "/files/input"))))
             marionette))

          (test-equal "Test file correctly received from share"
            "test-file-contents"
            (marionette-eval
             '(begin
                (use-modules (ice-9 rdelim))
                (zero?
                 (system* "rsync"
                          (string-append "rsync://localhost:"
                                         (number->string #$rsync-port)
                                         "/files/input")
                          "/tmp/output"))
                (call-with-input-file "/tmp/output"
                  (lambda (port)
                    (read-line port))))
             marionette))

          (test-end)
          (exit (= (test-runner-fail-count (test-runner-current)) 0)))))

  (gexp->derivation "rsync-test" test))

(define* %rsync-os
  ;; Return operating system under test.
  (let ((base-os
         (simple-operating-system
          (dhcp-client-service)
          (service rsync-service-type))))
    (operating-system
      (inherit base-os)
      (packages (cons* rsync
                       (operating-system-packages base-os))))))

(define %test-rsync
  (system-test
   (name "rsync")
   (description "Connect to a running RSYNC server.")
   (value (run-rsync-test %rsync-os))))
