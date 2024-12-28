{
  pkgs,
  self',
  ...
}: let
  spoofed-chrome = pkgs.writeShellScriptBin "spoofed-chrome" ''
    chromium --proxy-server="http://127.0.0.1:8080"
  '';
in {
  home.packages = [
    pkgs.chromium
    pkgs.nautilus
    pkgs.alacritty
    pkgs.vesktop
    pkgs.tor-browser
    pkgs.libreoffice
    #pkgs.webcord
    #pkgs.webcord-vencord
    self'.packages.spoof-dpi
    spoofed-chrome
  ];
}
