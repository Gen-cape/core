{
  pkgs,
  inputs',
  ...
}: {
  home.packages = with pkgs; [
    # inputs'.nixpkgs-stable.legacyPackages.wpsoffice
    onlyoffice-desktopeditors
  ];
}
