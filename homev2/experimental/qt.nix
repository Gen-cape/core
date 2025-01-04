{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf mkMerge;
  #cfg = osConfig.modules.style;
in {
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;

      # name = "Orchis-Dark";
      # package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Flat-Remix-Blue-Dark";
      package = pkgs.flat-remix-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };
  };
}
