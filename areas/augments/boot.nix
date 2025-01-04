{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkForce;
  inherit (pkgs) plymouth;
  grubThemePkg = pkgs.fetchFromGitHub {
    owner = "olivethepuffin";
    repo = "yorha-grub-theme";
    rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
    hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
  };
  grubSize = "2560x1440"; # also /yorha-3840x2160/" or /yorha-1920x1080/"

  grubTheme = "yorha-${grubSize}";
  plymouthTheme = "deus_ex";
in {
  config = {
    boot = {
      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      tmp.cleanOnBoot = true;

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
        configurationLimit = 2;
        timeoutStyle = "hidden";
        theme = "${grubThemePkg}/${grubTheme}}";
        splashImage = "${grubThemePkg}/${grubTheme}/background.png";
      };
    };
    plymouth = {
      enable = true;
      theme = plymouthTheme;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [plymouthTheme]; # By default we would install all themes
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
