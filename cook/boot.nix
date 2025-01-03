{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types mkMerge mkOverride mkForce;
  inherit (pkgs) plymouth;
in {
  config = {
    boot = {
      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      tmp.cleanOnBoot = true;
      kernelPackages = mkOverride 500 pkgs.linuxPackages_latest;

      loader = {
        timeout = mkForce 1;

        generationsDir.copyKernels = true;

        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
        "fbcon=nodefer"
        "logo.nologo"

        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"

        "vt.global_cursor_default=0"
      ];
    };

    loader = {
      grub = {
        enable = mkDefault true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
        theme = "${
          pkgs.fetchFromGitHub {
            owner = "olivethepuffin";
            repo = "yorha-grub-theme";
            rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
            hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
          }
          #}/yorha-3840x2160/";
          #}/yorha-1920x1080/";
        }/yorha-2560x1440/";

        splashImage = "${
          pkgs.fetchFromGitHub {
            owner = "olivethepuffin";
            repo = "yorha-grub-theme";
            rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
            hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
          }
        }/yorha-2560x1440/background.png";
        configurationLimit = 2;
      };
    };
    plymouth = let
      themeName = "deus_ex";
    in {
      enable = true;
      theme = themeName;
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [themeName];
        })
      ];
    };

    # make plymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };
  };
}
