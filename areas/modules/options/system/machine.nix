{
  config,
  lib,
  ...
}: let
  inherit (builtins) elemAt;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) enum listOf str nullOr bool package;
in {
  options.modules.device = {
    type = mkOption {
      type = enum ["laptop" "server"];
      default = "";
    };
    monitors = mkOption {
      type = listOf str;
      default = [];
    };
    cpu = {
      type = mkOption {
        type = nullOr (enum ["amd"]);
        default = null;
        description = "primary cpu device";
      };

      amd = {
        pstate = mkEnableOption "Pstate driver";
        zenpower = {
          enable = mkEnableOption "Zenpower driver";
          args = mkOption {
            type = str;
            default = "-p 0 -v 3C -f A0"; # Pstate 0, 1.175 voltage, 4000 clock speed
            description = ''
              The percentage of the maximum clock speed that the CPU will be limited to.
              trying to make it less furnace-ish;
            '';
          };
        };
      };
    };
    gpu = {
      type = mkOption {
        type = nullOr (enum ["amd"]);
        default = null;
        description = "Primary gpu device manufacturer";
      };
    };
    hasBluetooth = mkOption {
      type = bool;
      default = true;
      description = "Bluetooth capabilities of the system";
    };

    hasSound = mkOption {
      type = bool;
      default = true;
      description = "Sound capabilities of the system";
    };
  };

  options.modules.system = {
    sound.enable = mkEnableOption "sound soft pack";
    video.enable = mkEnableOption "enable video drivers";
    security = {
      fixWebcam = mkEnableOption "disabled webcam kernel module";
    };
  };
}
