{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.departure-mono
  ];

  services.tailscale = {
    enable = false;
    useRoutingFeatures = "client";
  };

  programs.dconf.enable = true;
}
