{
  inputs,
  osConfig,
  pkgs,
  lib,
  self,
  ...
}: let
  inherit (builtins) map;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatStringsSep;
  inherit (self.qol.services) mkHyprlandService;

  inherit (osConfig) modules;
  env = modules.ui;
  sys = modules.system;

  monitors = modules.device.monitors;

  wallpkgs = inputs.wallpkgs.packages.${pkgs.stdenv.system};
in {
  config =
    mkIf ((sys.video.enable) && (env.waylandBased && (env.desktop == "hyprland"))) {
    };
}
