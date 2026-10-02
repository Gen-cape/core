{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.departure-mono
  ];

  # Compats for desktop
  # programs.appimage = {
  #   enable = true;
  #   binfmt = true;
  # };
  # services.flatpak.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  # Power
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.libinput.enable = true;

  # Memory
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    enableNotifications = true;
  };
  systemd.oomd.enable = false;
  zramSwap = {
    enable = true;
    priority = 100;
  };

  # Base tools I want to have during problems
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    just
    jujutsu
  ];

  # Shell
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Usb mounting
  services.udisks2.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
