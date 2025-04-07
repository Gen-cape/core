{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf mkDefault mkForce mkEnableOption;
  inherit (lib.types) enum bool int str listOf nullOr package;
  cfg = config.core.boot;
  defaultGrubThemePkg = pkgs.fetchFromGitHub {
    owner = "olivethepuffin";
    repo = "yorha-grub-theme";
    rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
    hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
  };
  plymouth = pkgs.plymouth;
in {
  options.core.boot = {
    enable = mkEnableOption "custom boot configuration" // {default = true;};
    grub = {
      enable = mkEnableOption "GRUB bootloader" // {default = true;};
      size = mkOption {
        type = enum ["1920x1080" "2560x1440" "3840x2160"];
        default = "2560x1440";
        description = "GRUB splash screen size.";
      };
      timeout = mkOption {
        type = int;
        default = 1;
      };
      timeoutStyle = mkOption {
        type = enum ["hidden" "menu" "countdown"];
        default = "menu";
      };
      useOSProber = mkOption {
        type = bool;
        default = true;
      };
      configurationLimit = mkOption {
        type = int;
        default = 2;
      };
      theme = {
        enable = mkOption {
          type = bool;
          default = true;
        };
        package = mkOption {
          type = nullOr package;
          default = defaultGrubThemePkg;
        };
        name = mkOption {
          type = nullOr str;
          default = null;
        };
        customSplashImage = mkOption {
          type = nullOr str;
          default = null;
        };
      };
    };
    plymouth = {
      enable = mkOption {
        type = bool;
        default = true;
      };
      theme = mkOption {
        type = str;
        default = "deus_ex";
      };
      customThemePackages = mkOption {
        type = listOf package;
        default = [];
      };
      handleSuspend = mkOption {
        type = bool;
        default = true;
      };
    };
    silentBoot = {
      enable = mkOption {
        type = bool;
        default = true;
      };
      consoleLogLevel = mkOption {
        type = int;
        default = 0;
      };
      verboseInitrd = mkOption {
        type = bool;
        default = false;
      };
    };
    extraKernelParams = mkOption {
      type = listOf str;
      default = [];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Basic boot settings
    {
      boot = {
        consoleLogLevel = mkIf cfg.silentBoot.enable cfg.silentBoot.consoleLogLevel;
        initrd.verbose = cfg.silentBoot.verboseInitrd;
        tmp.cleanOnBoot = true;
      };
    }
    # GRUB loader settings
    (mkIf cfg.grub.enable {
      boot.loader = {
        timeout = mkForce cfg.grub.timeout;
        generationsDir.copyKernels = true;
        efi.canTouchEfiVariables = true;
        grub = let
          themeName =
            if cfg.grub.theme.name != null
            then cfg.grub.theme.name
            else "yorha-${cfg.grub.size}";
          themePath =
            if cfg.grub.theme.enable && cfg.grub.theme.package != null
            then "${cfg.grub.theme.package}/${themeName}"
            else null;
          splashPath =
            if cfg.grub.theme.customSplashImage != null
            then cfg.grub.theme.customSplashImage
            else if themePath != null
            then "${themePath}/background.png"
            else null;
        in {
          enable = mkDefault true;
          useOSProber = cfg.grub.useOSProber;
          efiSupport = true;
          device = "nodev";
          configurationLimit = cfg.grub.configurationLimit;
          timeoutStyle = cfg.grub.timeoutStyle;
          theme = themePath;
          splashImage = splashPath;
        };
      };
    })
    # Kernel parameters
    (mkIf cfg.silentBoot.enable {
      boot.kernelParams =
        [
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
        ]
        ++ cfg.extraKernelParams;
    })
    (mkIf (!cfg.silentBoot.enable) {
      boot.kernelParams = cfg.extraKernelParams;
    })
    # Plymouth configuration
    (mkIf cfg.plymouth.enable {
      boot.plymouth = {
        enable = true;
        theme = cfg.plymouth.theme;
        themePackages = with pkgs;
          [
            (adi1090x-plymouth-themes.override {selected_themes = [cfg.plymouth.theme];})
          ]
          ++ cfg.plymouth.customThemePackages;
      };
    })
    # Plymouth suspend/resume integration
    (mkIf (cfg.plymouth.enable && cfg.plymouth.handleSuspend) {
      powerManagement = {
        powerDownCommands = "${plymouth} --show-splash";
        resumeCommands = "${plymouth} --quit";
      };
    })
  ]);
}
