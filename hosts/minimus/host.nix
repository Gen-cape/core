{
  pkgs,
  lib,
  inputs,
  system, # Explicitly include system
  ...
}: let
  nix-mineral = inputs.nixpkgs.legacyPackages.${system}.fetchgit {
    url = "https://github.com/cynicsketch/nix-mineral.git";
    rev = "196ab5bf2369cffba466a9c2ee0a2c53bf52426a";
    sha256 = "sha256-xtj//XV7AAQQXE8z/blNPGFeo+NCTB324azk+cDdCpQ=";
  };
in {
  imports = [
    (inputs.nixpkgs + "/nixos/modules/profiles/minimal.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/headless.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/perlless.nix")
    "${nix-mineral}/nix-mineral.nix"
    ({lib, ...}: {
      # Stub module to define services.nix-daemon.logWatches
      options = {
        services.nix-daemon = lib.mkOption {
          type = lib.types.submoduleWith {
            modules = [
              {
                options.logWatches = lib.mkOption {
                  type = lib.types.bool;
                  default = true; # Mimic original default
                  description = "Stub definition for nix-daemon.logWatches to allow overriding when the original module is unavailable.";
                };
              }
            ];
          };
          default = {}; # Mimic original default for the submodule container
          description = "Stub definition for services.nix-daemon submodule container.";
        };
      };
    })
    ({lib, ...}: {
      # Stub module to define boot.kernel.structuredExtraConfig
      options = {
        boot.kernel.structuredExtraConfig = lib.mkOption {
          type = lib.types.attrsOf lib.kernel.option;
          default = {};
          description = "Stub definition for boot.kernel.structuredExtraConfig.";
        };
      };
    })
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernel.structuredExtraConfig = with lib.kernel; {
      # Filesystems (disabling unnecessary)
      BTRFS_FS = no;
      XFS_FS = no;
      # JFS_FS = no; # Example
      # F2FS_FS = no; # Example

      # Networking (disabling unnecessary)
      IPV6 = no; # If IPv6 is not needed
      AX25 = no; # Amateur Radio
      NETROM = no; # Amateur Radio
      ROSE = no; # Amateur Radio
      WANPIPE = no; # WAN Router drivers
      ATM = no; # Asynchronous Transfer Mode

      # Sound (headless, no point)
      SOUND = no;

      # Other potentially unneeded features for a minimal VM/server
      # FB = no; # Framebuffer support if no console needed
      # USB_SUPPORT = no; # If no USB devices are ever attached
      # HID_SUPPORT = no; # Human Interface Devices
      BLUETOOTH = no; # Bluetooth support
    };

    # Networking
    networking.hostName = "minimus";
    networking.useDHCP = lib.mkDefault true;
    networking.interfaces.eth0.useDHCP = lib.mkDefault true;

    # Core Disables for Minimization (https://sidhion.com/blog/nixos_server_issues/)
    nix = {
      enable = true;
      registry = lib.mkForce {};
      settings.flake-registry = lib.mkForce "";
      settings.auto-optimise-store = lib.mkForce false;
    };

    systemd.package = pkgs.systemdMinimal; # Use minimal systemd

    services = {
      udev.enable = false; # Disable udev if not strictly needed
      lvm.enable = false; # Disable LVM if not used
      getty.autologinUser = lib.mkForce null; # Disable autologin
      nix-daemon.logWatches = lib.mkForce false;
    };

    security.sudo.enable = false; # Disable sudo

    documentation.enable = false;
    documentation.nixos.enable = false;
    documentation.man.enable = false;

    # Disabled security nix wrappers modules (pointless mount brainrot)

    i18n.extraLocales = ["C.UTF-8/UTF-8"]; # Minimal locale

    environment.systemPackages = [pkgs.vim]; # Use vim

    programs.bash = {
      promptInit = lib.mkForce "";
      interactiveShellInit = lib.mkForce "";
      shellInit = lib.mkForce "";
      shellAliases = lib.mkForce {};
    };

    # Further Potential Optimizations
    nixpkgs.overlays = [
      (self: super: {
        # Override coreutils to include only essential binaries
        coreutils = super.coreutils.overrideAttrs (old: {
          pname = old.pname + "-minimal";
          postInstall =
            (old.postInstall or "")
            + ''
              # Keep only essential binaries as specified
              local essential_bins="ls cat echo rm mkdir mv true false ln sleep readlink stty uname id whoami groups mktemp realpath sync head tail wc df du pwd env nice nohup printenv printf tee tty test touch tr uniq uptime users who yes mount umount"

              mkdir -p $out/bin-temp
              for bin_name in $essential_bins; do
                if [ -f "$out/bin/$bin_name" ]; then
                  mv "$out/bin/$bin_name" "$out/bin-temp/"
                fi
              done

              # Remove all original binaries and then move back the essential ones
              rm -rf $out/bin/*
              mv $out/bin-temp/* $out/bin/
              rm -rf $out/bin-temp

              # Also remove man pages and info pages from coreutils
              rm -rf $out/share/man
              rm -rf $out/share/info
            '';
        });
      })
      (self: super: {
        # Experiment: Replace `less` and `which` with dummy scripts.
        # Removing utilities like gzip or tar is highly risky as NixOS
        # itself might depend on them for basic operations.
        less = super.writeTextFile {
          name = "less-disabled";
          executable = true;
          text = "#!${super.stdenv.shell}\necho 'less disabled for minimus host'";
        };
        which = super.writeTextFile {
          name = "which-disabled";
          executable = true;
          text = "#!${super.stdenv.shell}\necho 'which disabled for minimus host'";
        };
      })
    ];

    system.stateVersion = "25.05";

    # Reminder: After building the system, 'nix-store --optimise' can be run
    # on the resulting system closure to potentially reduce its size further.
    # This is a post-build step, not a NixOS configuration option.
  };
}
