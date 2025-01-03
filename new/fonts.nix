{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono
      nerdfonts
      noto-fonts
      vistafonts
      corefonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      nerd-fonts.jetbrains-mono
    ];
  };
}
