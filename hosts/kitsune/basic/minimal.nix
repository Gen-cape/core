{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    btop
    curl
    git
    openssl
    unzip
    vim
    wget
    zip
  ];
  programs.fish.enable = true;
  environment.defaultPackages = [];
  documentation.enable = false;
  xdg.icons.enable = false;
  xdg.mime.enable = false;
  xdg.sounds.enable = false;
}
