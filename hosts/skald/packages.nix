{
  pkgs,
  inputs',
  ...
}: {
  programs.gpu-screen-recorder.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    # inputs'.search-flake-inputs.packages.default
    # inputs'.zen-browser.packages.twilight
    inputs'.neovim-riptide.packages.default
    # inputs'.hover-rs.packages.default
    # inputs'.flint.packages.default
    # inputs'.nix-search-tv.packages.default
    # inputs'.riptide.packages.ulss

    # Gaming & Launchers (umu-launcher is in gaming.nix)
    heroic
    hydralauncher
    r2modman
    bottles
    protontricks

    # Screen Recording & Display
    gpu-screen-recorder-gtk
    matugen
    wtype

    # Audio & Hardware Monitoring
    pavucontrol
    easyeffects
    coppwr
    amdgpu_top

    # File & Disk Management
    nautilus
    ncdu
    tmsu
    qbittorrent

    # Media Viewers & Editors
    nomacs
    krita
    vlc
    zathura

    # Productivity & Terminal Utilities
    git
    jujutsu
    ripgrep
    btop
    hyperfine
    isd
    npins

    # Task Management (Taskwarrior stack)
    # taskwarrior3
    # taskwarrior-tui
    # timewarrior

    # System Utilities & Inspection
    networkmanagerapplet
    nix-inspect
    nix-melt
    tor-browser
  ];
}
