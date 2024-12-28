{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 14;
      window = {
        opacity = mkForce 0.4;
        blur = true;
        dynamic_padding = true;
      };
      terminal.shell = pkgs.fish + /bin/fish;
    };
  };
}
