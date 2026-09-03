{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  services.tailscale = {
    enable = false;
    useRoutingFeatures = "client";
  };

  programs.dconf.enable = true;
}
