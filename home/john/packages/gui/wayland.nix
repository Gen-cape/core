{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules meta;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && (sys.video.enable && meta.waylandBased)) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
