{pkgs, ...}: let
  # miku = pkgs.callPackage (
  #   {
  #     stdenv,
  #     fetchFromGitHub,
  #   }:
  #     stdenv.mkDerivation rec {
  #       pname = "hatsune-miku-windows-linux-cursors";
  #       version = "1.2.6";
  #
  #       src = fetchFromGitHub {
  #         owner = "supermariofps";
  #         repo = "hatsune-miku-windows-linux-cursors";
  #         rev = version;
  #         hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
  #       };
  #
  #       installPhase = ''
  #         runHook preInstall
  #
  #         install -dm 0755 $out/share/icons/Hatsune-Miku
  #         cp -r miku-cursor-linux/* $out/share/icons/Hatsune-Miku/
  #
  #         runHook postInstall
  #       '';
  #     }
  # ) {};
in {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    # hyprcursor.enable = true;
    # name = "Hatsune-Miku";
    # package = miku;
    # name = "Banana";
    # package = pkgs.banana-cursor;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 20;
  };
}
