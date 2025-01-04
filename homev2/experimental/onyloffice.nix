{
  pkgs,
  inputs',
  ...
}: {
  home.packages = [
    pkgs.onlyoffice-desktopeditors
    pkgs.qimgv
    pkgs.pqiv
    pkgs.dooit
    pkgs.r2modman
    pkgs.jujutsu
    pkgs.lazyjj
    pkgs.gg-jj
    pkgs.julia_19
    pkgs.helvum
    pkgs.urn-timer

    # pkgs.open-webui
    # inputs'.nixpkgs-stable.legacyPackages.open-webui
    # pkgs.gale
    # inputs'.nixpkgs-stable.legacyPackages.gale
  ];
}
