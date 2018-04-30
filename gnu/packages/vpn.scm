;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2013, 2016, 2018 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2015 Jeff Mickey <j@codemac.net>
;;; Copyright © 2016, 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2017 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2018 Pierre Langlois <pierre.langlois@gmx.com>
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

(define-module (gnu packages vpn)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages check)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml))

(define-public gvpe
  (package
    (name "gvpe")
    (version "3.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/gvpe/gvpe-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1v61mj25iyd91z0ir7cmradkkcm1ffbk52c96v293ibsvjs2s2hf"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Remove the outdated bundled copy of glibc's getopt, which
                  ;; provides a 'getopt' declaration that conflicts with that
                  ;; of glibc 2.26.
                  (substitute* "lib/Makefile.in"
                    (("getopt1?\\.(c|h|\\$\\(OBJEXT\\))") ""))
                  (for-each delete-file
                            '("lib/getopt.h" "lib/getopt.c"))))))
    (build-system gnu-build-system)
    (home-page "http://software.schmorp.de/pkg/gvpe.html")
    (inputs `(("openssl" ,openssl)
              ("zlib" ,zlib)))
    (synopsis "Secure VPN among multiple nodes over an untrusted network")
    (description
     "The GNU Virtual Private Ethernet creates a virtual network
with multiple nodes using a variety of transport protocols.  It works
by creating encrypted host-to-host tunnels between multiple
endpoints.")
    (license license:gpl3+)))

(define-public vpnc
  (package
   (name "vpnc")
   (version "0.5.3")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://www.unix-ag.uni-kl.de/~massar/vpnc/vpnc-"
                                version ".tar.gz"))
            (sha256 (base32
                     "1128860lis89g1s21hqxvap2nq426c9j4bvgghncc1zj0ays7kj6"))))
   (build-system gnu-build-system)
   (inputs `(("libgcrypt" ,libgcrypt)
             ("perl" ,perl)
             ("vpnc-scripts" ,vpnc-scripts)))
   (arguments
    `(#:tests? #f ; there is no check target
      #:phases
      (modify-phases %standard-phases
        (add-after 'unpack 'use-store-paths
          (lambda* (#:key inputs outputs #:allow-other-keys)
            (let ((out          (assoc-ref outputs "out"))
                  (vpnc-scripts (assoc-ref inputs  "vpnc-scripts")))
              (substitute* "config.c"
                (("/etc/vpnc/vpnc-script")
                 (string-append vpnc-scripts "/etc/vpnc/vpnc-script")))
              (substitute* "Makefile"
                (("ETCDIR=.*")
                 (string-append "ETCDIR=" out "/etc/vpnc\n"))
                (("PREFIX=.*")
                 (string-append "PREFIX=" out "\n")))
              #t)))
        (delete 'configure))))          ; no configure script
   (synopsis "Client for Cisco VPN concentrators")
   (description
    "vpnc is a VPN client compatible with Cisco's EasyVPN equipment.
It supports IPSec (ESP) with Mode Configuration and Xauth.  It supports only
shared-secret IPSec authentication with Xauth, AES (256, 192, 128), 3DES,
1DES, MD5, SHA1, DH1/2/5 and IP tunneling.  It runs entirely in userspace.
Only \"Universal TUN/TAP device driver support\" is needed in the kernel.")
   (license license:gpl2+) ; some file are bsd-2, see COPYING
   (home-page "http://www.unix-ag.uni-kl.de/~massar/vpnc/")))

(define-public vpnc-scripts
  (let ((commit "6f87b0fe7b20d802a0747cc310217920047d58d3"))
    (package
      (name "vpnc-scripts")
      (version (string-append "20161214." (string-take commit 7)))
      (source (origin
                (method git-fetch)
                (uri
                 (git-reference
                  (url "git://git.infradead.org/users/dwmw2/vpnc-scripts.git")
                  (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0pa36w4wlyyvfb66cayhans99wsr2j5si2fvfr7ldfm512ajwn8h"))))
      (build-system gnu-build-system)
      (inputs `(("coreutils" ,coreutils)
                ("grep" ,grep)
                ("iproute2" ,iproute)    ; for ‘ip’
                ("net-tools" ,net-tools) ; for ‘ifconfig’, ‘route’
                ("sed" ,sed)
                ("which" ,which)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'use-relative-paths
             ;; Patch the scripts to work with and use relative paths.
             (lambda* _
               (for-each (lambda (script)
                           (substitute* script
                             (("^PATH=.*") "")
                             (("(/usr|)/s?bin/") "")
                             (("\\[ +-x +([^]]+) +\\]" _ command)
                              (string-append "command -v >/dev/null 2>&1 "
                                             command))))
                         (find-files "." "^vpnc-script"))
               #t))
           (delete 'configure)          ; no configure script
           (replace 'build
             (lambda _
               (zero? (system* "gcc" "-o" "netunshare" "netunshare.c"))))
           (replace 'install
             ;; There is no Makefile; manually install the relevant files.
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (etc (string-append out "/etc/vpnc")))
                 (for-each (lambda (file)
                             (install-file file etc))
                           (append (find-files "." "^vpnc-script")
                                   (list "netunshare"
                                         "xinetd.netns.conf")))
                 #t)))
           (add-after 'install 'wrap-scripts
             ;; Wrap scripts with paths to their common hard dependencies.
             ;; Optional dependencies will need to be installed by the user.
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 (for-each
                  (lambda (script)
                    (wrap-program script
                      `("PATH" ":" prefix
                        ,(map (lambda (name)
                                (let ((input (assoc-ref inputs name)))
                                  (string-append input "/bin:"
                                                 input "/sbin")))
                              (list "coreutils"
                                    "grep"
                                    "iproute2"
                                    "net-tools"
                                    "sed"
                                    "which")))))
                  (find-files (string-append out "/etc/vpnc/vpnc-script")
                              "^vpnc-script"))))))
         #:tests? #f))                  ; no tests
      (home-page "http://git.infradead.org/users/dwmw2/vpnc-scripts.git")
      (synopsis "Network configuration scripts for Cisco VPN clients")
      (description
       "This set of scripts configures routing and name services when invoked
by the VPNC or OpenConnect Cisco @dfn{Virtual Private Network} (VPN) clients.

The default @command{vpnc-script} automatically configures most common
connections, and provides hooks for performing custom actions at various stages
of the connection or disconnection process.

Alternative scripts are provided for more complicated set-ups, or to serve as an
example for writing your own.  For example, @command{vpnc-script-sshd} contains
the entire VPN in a network namespace accessible only through SSH.")
      (license license:gpl2+))))

(define-public ocproxy
  (package
    (name "ocproxy")
    (version "1.60")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/cernekee/ocproxy/archive/v"
                    version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1b4rg3xq5jnrp2l14sw0msan8kqhdxmsd7gpw9lkiwvxy13pcdm7"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)))
    (inputs
     `(("libevent" ,libevent)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'autogen
           (lambda _ (invoke "sh" "autogen.sh"))))))
    (home-page "https://github.com/cernekee/ocproxy")
    (synopsis "OpenConnect proxy")
    (description
     "User-level @dfn{SOCKS} and port forwarding proxy for OpenConnect based
on LwIP.  When using ocproxy, OpenConnect only handles network activity that
the user specifically asks to proxy, so the @dfn{VPN} interface no longer
\"hijacks\" all network traffic on the host.")
    (license license:bsd-3)))

(define-public openconnect
  (package
   (name "openconnect")
   (version "7.08")
   (source (origin
            (method url-fetch)
            (uri (string-append "ftp://ftp.infradead.org/pub/openconnect/"
                                "openconnect-" version ".tar.gz"))
            (sha256 (base32
                     "00wacb79l2c45f94gxs63b9z25wlciarasvjrb8jb8566wgyqi0w"))))
   (build-system gnu-build-system)
   (inputs
    `(("libxml2" ,libxml2)
      ("gnutls" ,gnutls)
      ("vpnc-scripts" ,vpnc-scripts)
      ("zlib" ,zlib)))
   (native-inputs
    `(("gettext" ,gettext-minimal)
      ("pkg-config" ,pkg-config)))
   (arguments
    `(#:configure-flags
      `(,(string-append "--with-vpnc-script="
                        (assoc-ref %build-inputs "vpnc-scripts")
                        "/etc/vpnc/vpnc-script"))))
   (synopsis "Client for Cisco VPN")
   (description
    "OpenConnect is a client for Cisco's AnyConnect SSL VPN, which is
supported by the ASA5500 Series, by IOS 12.4(9)T or later on Cisco SR500,
870, 880, 1800, 2800, 3800, 7200 Series and Cisco 7301 Routers,
and probably others.")
   (license license:lgpl2.1)
   (home-page "http://www.infradead.org/openconnect/")))

(define-public openvpn
  (package
    (name "openvpn")
    (version "2.4.6")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://swupdate.openvpn.org/community/releases/openvpn-"
                    version ".tar.xz"))
              (sha256
               (base32
                "09lck4wmkas3iyrzaspin9gn3wiclqb1m9sf8diy7j8wakx38r2g"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags '("--enable-iproute2=yes")))
    (native-inputs
     `(("iproute2" ,iproute)))
    (inputs
     `(("lz4" ,lz4)
       ("lzo" ,lzo)
       ("openssl" ,openssl)
       ("linux-pam" ,linux-pam)))
    (home-page "https://openvpn.net/")
    (synopsis "Virtual private network daemon")
    (description
     "OpenVPN implements virtual private network (@dfn{VPN}) techniques
for creating secure point-to-point or site-to-site connections in routed or
bridged configurations and remote access facilities.  It uses a custom
security protocol that utilizes SSL/TLS for key exchange.  It is capable of
traversing network address translators (@dfn{NAT}s) and firewalls.")
    (license license:gpl2)))

(define-public tinc
  (package
    (name "tinc")
    (version "1.0.33")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://tinc-vpn.org/packages/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "1x0hpfz13vn4pl6dcpnls6xq3rfcbdsg90awcfn53ijb8k35svvz"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags
       '("--sysconfdir=/etc"
         "--localstatedir=/var")))
    (inputs `(("zlib" ,zlib)
              ("lzo" ,lzo)
              ("openssl" ,openssl)))
    (home-page "http://tinc-vpn.org")
    (synopsis "Virtual Private Network (VPN) daemon")
    (description
     "Tinc is a VPN that uses tunnelling and encryption to create a secure
private network between hosts on the internet.")
    (license license:gpl2+)))

(define-public sshuttle
  (package
    (name "sshuttle")
    (version "0.78.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri name version))
       (sha256
        (base32
         "0pqk43kd7crqhg6qgnl8kapncwgw1xgaf02zarzypcw64kvdih9h"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-setuptools-scm" ,python-setuptools-scm)
       ;; For tests only.
       ("python-mock" ,python-mock)
       ("python-pytest" ,python-pytest)
       ("python-pytest-runner" ,python-pytest-runner)))
    (home-page "https://github.com/sshuttle/sshuttle")
    (synopsis "VPN that transparently forwards connections over SSH")
    (description "sshuttle creates an encrypted virtual private network (VPN)
connection to any remote server to which you have secure shell (SSH) access.
The only requirement is a suitable version of Python on the server;
administrative privileges are required only on the client.  Unlike most VPNs,
sshuttle forwards entire sessions, not packets, using kernel transparent
proxying.  This makes it faster and more reliable than SSH's own tunneling and
port forwarding features.  It can forward both TCP and UDP traffic, including
DNS domain name queries.")
    (license license:lgpl2.0))) ; incorrectly identified as GPL in ‘setup.py’

(define-public sshoot
  (package
    (name "sshoot")
    (version "1.2.6")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri name version))
       (sha256
        (base32
         "1ccgh0hjyxrwkgy3hnxz3hgbjbs0lmfs25d5l5jam0xbpcpj63h0"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-paths
           (lambda _
             (substitute* "sshoot/tests/test_manager.py"
               (("/bin/sh") (which "sh")))
             #t)))))
    (inputs
     `(("python-argcomplete" ,python-argcomplete)
       ("python-prettytable" ,python-prettytable)
       ("python-pyyaml" ,python-pyyaml)))
    ;; For tests only.
    (native-inputs
     `(("python-fixtures" ,python-fixtures)
       ("python-pbr" ,python-pbr)
       ("python-testtools" ,python-testtools)))
    (home-page "https://github.com/albertodonato/sshoot")
    (synopsis "sshuttle VPN session manager")
    (description "sshoot provides a command-line interface to manage multiple
@command{sshuttle} virtual private networks.  It supports flexible profiles
with configuration options for most of @command{sshuttle}’s features.")
    (license license:gpl3+)))
