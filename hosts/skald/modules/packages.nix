{
  pkgs,
  inputs',
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs'.quickshell.packages.quickshell
    inputs'.rose-pine-hyprcursor.packages.default
    inputs'.search-flake-inputs.packages.default
    inputs'.zen-browser.packages.default
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
    gamemode
    bottles
    nomacs

    pkgs.qimgv
    pkgs.pqiv
    pkgs.dooit
    pkgs.r2modman
    pkgs.lazyjj
    pkgs.gg-jj
    pkgs.julia_19
    pkgs.urn-timer
    pkgs.chromium
    pkgs.nautilus
    pkgs.alacritty
    pkgs.vesktop
    pkgs.tor-browser
    pkgs.libreoffice
    pkgs.gotop
    pkgs.activate-linux
    pkgs.nix-melt
    pkgs.nix-inspect
    pkgs.zathura
  ];
}
