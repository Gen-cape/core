{
  pkgs,
  inputs',
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs'.quickshell.packages.quickshell
    inputs'.rose-pine-hyprcursor.packages.default
    qbittorrent
    obs-studio
    krita
    vlc
    libreoffice-qt6-fresh
    r2modman
    protontricks
    matugen

    git
    amdgpu_top

    helvum
    jujutsu
    pkgs.qimgv
    pkgs.pqiv
    pkgs.dooit
    pkgs.r2modman
    pkgs.lazyjj
    pkgs.gg-jj
    pkgs.julia_19
    pkgs.urn-timer
  ];
}
