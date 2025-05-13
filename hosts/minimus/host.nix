{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    (inputs.nixpkgs + "/nixos/modules/profiles/minimal.nix" )
    (inputs.nixpkgs + "/nixos/modules/profiles/headless.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/perlless.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest_minimal;

  boot.kernelConfig = {
    # Filesystems (disabling unnecessary)
    BTRFS_FS  = lib.mkForce false;
    XFS_FS    = lib.mkForce false;
    # JFS_FS  = lib.mkForce false;  # Example
    # F2FS_FS = lib.mkForce false; # Example

    # Networking (disabling unnecessary)
    IPV6    = lib.mkForce false;    # If IPv6 is not needed
    AX25    = lib.mkForce false;    # Amateur Radio
    NETROM  = lib.mkForce false;  # Amateur Radio
    ROSE    = lib.mkForce false;    # Amateur Radio
    WANPIPE = lib.mkForce false; # WAN Router drivers
    ATM     = lib.mkForce false;     # Asynchronous Transfer Mode

    # Sound (headless, no point)
    SOUND = lib.mkForce false;

    # Other potentially unneeded features for a minimal VM/server
    # FB          = lib.mkForce false; # Framebuffer support if no console needed
    # USB_SUPPORT = lib.mkForce false; # If no USB devices are ever attached
    # HID_SUPPORT = lib.mkForce false; # Human Interface Devices
    BLUETOOTH     = lib.mkForce false; # Bluetooth support
  };

  # Networking
  networking.hostName                = "minimus";
  networking.useDHCP                 = lib.mkDefault true;
  networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  # Core Disables for Minimization (https://sidhion.com/blog/nixos_server_issues/)
  nix = {
    enable = true; # Nix is enabled
    registry = lib.mkForce {};
    settings.flake-registry = lib.mkForce "";
    settings.auto-optimise-store = lib.mkForce false; # Disable automatic store optimization
  };
  services.nix-daemon.logWatches = lib.mkForce false; # Disable excessive logging from nix-daemon
  systemd.package = pkgs.systemdMinimal;              # Use minimal systemd
  services.udev.enable = false;                       # Disable udev if not strictly needed
  services.lvm.enable = false;                        # Disable LVM if not used
  security.sudo.enable = false;                       # Disable sudo

  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;

  services.getty.autologinUser = lib.mkForce null;    # Disable autologin
  services.mingetty.autologinUser = lib.mkForce null; # Disable autologin

  # Disabled security nix wrappers modules (pointless mount brainrot)
  disabledModules = ["security/wrappers/default.nix"];
  options.security = {
    wrappers = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for disabled security.wrappers";
    };
    wrapperDir = lib.mkOption {
      type = lib.types.path;
      default = "/run/wrappers/bin";
      description = "Stub for disabled security.wrapperDir";
    };
  };

  i18n.supportedLocales = ["C.UTF-8/UTF-8"];      # Minimal locale
  environment.noXlibs = true;                     # Ensure no X11 libraries

  environment.systemPackages = [pkgs.vimMinimal]; # Use vimMinimal

  # programs.bash.enable = false; # Disable bash Bye Bye
  programs.bash.promptInit = lib.mkForce "";
  programs.bash.interactiveShellInit = lib.mkForce "";
  programs.bash.shellInit = lib.mkForce "";
  programs.bash.shellAliases = lib.mkForce {};

  # Further Potential Optimizations from Article:

  nixpkgs.overlays =
    lib.mkDefault []
    ++ [
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
}
