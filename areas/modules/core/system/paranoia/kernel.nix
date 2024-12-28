{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types optionals mkForce;

  sys = config.modules.system;
in {
  # THANK YOU RAF *heart*
  config = {
    security = {
      protectKernelImage = true; # no hibernation

      lockKernelModules = false; # wireguard worky

      forcePageTableIsolation = true; # no Meltdown

      allowUserNamespaces = true;

      allowSimultaneousMultithreading = true;
    };

    boot = {
      # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
      kernelParams = [
        "nohibernate"

        "randomize_kstack_offset=on"

        "vsyscall=none"

        "slab_nomerge"

        # FUCK powertop
        "debugfs=off"

        "oops=panic"

        "module.sig_enforce=1"

        # assert nixos dominance
        "lockdown=confidentiality"

        "page_poison=on"

        "page_alloc.shuffle=1"

        # "slub_debug=FZP" # i dunno

        "rootflags=noatime"

        #"lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"

        # Plymouth
        "fbcon=nodefer"

        "integrity_audit=1"
      ];

      # I trust on this one :3
      blacklistedKernelModules = lib.concatLists [
        # Obscure network protocols
        [
          "dccp" # Datagram Congestion Control Protocol
          "sctp" # Stream Control Transmission Protocol
          "rds" # Reliable Datagram Sockets
          "tipc" # Transparent Inter-Process Communication
          "n-hdlc" # High-level Data Link Control
          "netrom" # NetRom
          "x25" # X.25
          "ax25" # Amateur X.25
          "rose" # ROSE
          "decnet" # DECnet
          "econet" # Econet
          "af_802154" # IEEE 802.15.4
          "ipx" # Internetwork Packet Exchange
          "appletalk" # Appletalk
          "psnap" # SubnetworkAccess Protocol
          "p8022" # IEEE 802.3
          "p8023" # Novell raw IEEE 802.3
          "can" # Controller Area Network
          "atm" # ATM
        ]

        # Old or rare or insufficiently audited filesystems
        [
          "adfs" # Active Directory Federation Services
          "affs" # Amiga Fast File System
          "befs" # "Be File System"
          "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
          "cifs" # Common Internet File System
          "cramfs" # compressed ROM/RAM file system
          "efs" # Extent File System
          "erofs" # Enhanced Read-Only File System
          "exofs" # EXtended Object File System
          "freevxfs" # Veritas filesystem driver
          "f2fs" # Flash-Friendly File System
          "vivid" # Virtual Video Test Driver (unnecessary, and a historical cause of escalation issues)
          "gfs2" # Global File System 2
          "hpfs" # High Performance File System (used by OS/2)
          "hfs" # Hierarchical File System (Macintosh)
          "hfsplus" # " same as above, but with extended attributes
          "jffs2" # Journalling Flash File System (v2)
          "jfs" # Journaled File System - only useful for VMWare sessions
          "ksmbd" # SMB3 Kernel Server
          "minix" # minix fs - used by the minix OS
          "nfsv3" # " (v3)
          "nfsv4" # Network File System (v4)
          "nfs" # Network File System
          "nilfs2" # New Implementation of a Log-structured File System
          "omfs" # Optimized MPEG Filesystem
          "qnx4" # extent-based file system used by the QNX4 and QNX6 OSes
          "qnx6" # "
          "squashfs" # compressed read-only file system (used by live CDs)
          "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
          "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
        ]

        # Disable Thunderbolt and FireWire to prevent DMA attacks
        [
          "thunderbolt"
          "firewire-core"
        ]

        # You might possibly want your webcam to work.
        # We whitelist the module if the system wants
        # webcam to work
        (optionals (!sys.security.fixWebcam) [
          "uvcvideo" # this is why your webcam no worky
        ])

        # if bluetooth is enabled, whitelist the module
        # necessary for bluetooth dongles to work
        (optionals (!sys.bluetooth.enable) [
          "bluetooth" # let bluetooth work
          "btusb" # let bluetooth dongles work
        ])
      ];
    };
  };
}
