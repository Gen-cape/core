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
  ];
}
