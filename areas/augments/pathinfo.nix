{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) path;
in {
  options.core.path = mkOption {
    type = path;
    default = "~/core";
    description = ''
      The path to the core.
    '';
  };
}
