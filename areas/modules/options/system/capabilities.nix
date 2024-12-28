{
  config,
  lib,
  ...
}: let
  inherit (builtins) elemAt;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) enum listOf str nullOr bool package;
in {
  options.modules.system = {
    mainUser = mkOption {
      type = enum config.modules.system.users;
      default = elemAt config.modules.system.users 0;
    };

    users = mkOption {
      type = listOf str;
      default = ["john"];
      description = "A list of home-manager users on the system.";
    };

    #sound.enable = mkEnableOption "sound related programs and settings";

    #video.enable = mkEnableOption "video drivers and gui";

    bluetooth.enable = mkEnableOption "bluetooth tweaks";

    printing = {
      enable = mkEnableOption "oh no....";
      extraDrivers = mkOption {
        type = listOf str;
        default = [];
        description = "extra drivers for printing";
      };
    };
  };
}
