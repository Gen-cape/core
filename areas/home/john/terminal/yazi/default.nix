{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ripdrag
    pkgs.exiftool
    pkgs.zip
    pkgs.p7zip
    pkgs.trash-cli
    pkgs.fzf
    pkgs.yazi
  ];
}
