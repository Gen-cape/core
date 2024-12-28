{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  # (isx86Linux pkgs) -> true
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;
  sys = config.modules.system;
in {
  config = mkIf sys.video.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = isx86Linux pkgs;
      };
    };
  };
}
