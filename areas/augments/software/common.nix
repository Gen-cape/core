{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
  ];

  services.tailscale = {
    enable = false;
    useRoutingFeatures = "client";
  };
}
