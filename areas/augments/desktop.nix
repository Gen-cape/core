{pkgs, ...}: {
  fonts.packages = with pkgs; [
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
    # alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Usb mounting
  services.udisks2.enable = true;
  systemd.user.services.udiskie = {
    description = "udiskie automount daemon";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${pkgs.udiskie}/bin/udiskie --automount --notify --smart-tray --appindicator";
      Restart = "on-failure";
      RestartSec = "5";
    };
  };

  hardware.graphics = {
    enable = true;
    # enable32Bit = true;
  };
}
