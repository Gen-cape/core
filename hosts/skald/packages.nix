{
  pkgs,
  inputs',
  ...
}: {
  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    # inputs'.quickshell.packages.quickshell
    inputs'.search-flake-inputs.packages.default
    # inputs'.zen-browser.packages.default
    inputs'.zen-browser.packages.twilight
    inputs'.neovim-riptide.packages.default
    inputs'.hover-rs.packages.default
    inputs'.flint.packages.default
    inputs'.nix-search-tv.packages.default

    inputs'.riptide.packages.ulss

    heroic
    inputs'.nixpkgs.legacyPackages.umu-launcher
    hydralauncher

    npins
    gpu-screen-recorder
    gpu-screen-recorder-gtk

    ncdu

    neovide
    television
    nix-search-cli
    wtype
    isd

    vscode

    qbittorrent
    obs-studio
    krita
    vlc
    libreoffice-qt6-fresh

    (pkgs.r2modman.overrideAttrs (finalAttrs: rec {
      pname = "r2modman";
      version = "3.1.57";
      src = pkgs.fetchFromGitHub {
        owner = "ebkr";
        repo = "r2modmanPlus";
        rev = "v${finalAttrs.version}";
        hash = "sha256-1b24tclqXGx85BGFYL9cbthLScVWau2OmRh9YElfCLs=";
      };
      offlineCache = pkgs.fetchYarnDeps {
        yarnLock = "${src}/yarn.lock";
        hash = "sha256-3SMvUx+TwUmOur/50HDLWt0EayY5tst4YANWIlXdiPQ=";
      };
    }))

    protontricks
    matugen

    networkmanagerapplet
    pavucontrol
    easyeffects

    git
    amdgpu_top

    helvum

    qpwgraph
    easyeffects
    # raysession
    # patchance
    # pw-viz

    jujutsu
    tmsu

    gamemode
    bottles
    nomacs
    ripgrep
    # television
    rpg-cli
    confetty

    # (symlinkJoin {
    #   name = "Obsidian";
    #   paths = with pkgs; [
    #     obsidian
    #     pandoc
    #   ];
    # })
    btop
    gotop
    hyperfine
    timewarrior
    taskwarrior-tui
    taskwarrior3

    pkgs.qimgv
    pkgs.pqiv
    pkgs.dooit
    # pkgs.lazyjj
    # pkgs.gg-jj
    # pkgs.julia_19
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
