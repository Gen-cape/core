{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.system.security = {
    usbguard.enable = mkEnableOption "enable usb protection";
  };
}
