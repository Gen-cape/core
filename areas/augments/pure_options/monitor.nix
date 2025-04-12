{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  options.core.scaling = mkOption {
    type = str;
    default = "1.0";
    description = ''
      Monitor scaling (used in your wm/compositor)
    '';
  };
}
