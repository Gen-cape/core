{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types);
in {
  options.modules = {
    system.programs = {
      firefox.enable = mkEnableOption "firefox browser" // {default = true;};
    };
  };
}
