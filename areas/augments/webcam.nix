{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) enum;
in {
  options.core.webcam = mkOption {
    type = enum ["worky" "notworky" "maybe" "dunno" "yes" "no" "noworky>:(" "worky:)" true false];
    default = "noworky>:(";
    description = ''
      Enable webcam support.
    '';
  };
  config = mkIf (builtins.elem config.core.webcam ["notworky" "dunno" "no" "noworky>:(" false]) {
    boot.blacklistedKernelModules = ["uvcvideo"];
  };
}
