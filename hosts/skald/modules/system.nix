{
  pkgs,
  inputs',
  ...
}: {
  boot = {
    # kernelPackages = inputs'.chaotic.legacyPackages.linuxPackages_cachyos;
    supportedFilesystems = ["ntfs"];
  };

  services.flatpak.enable = true;
  services.input-remapper.enable = true;
  programs.kdeconnect.enable = true;

  security.pam.services.swaylock = {
    fprintAuth = false;
  };
  security.pam.services.hyprlock = {};

  environment.systemPackages = with pkgs; [
    obsidian
    pandoc
  ];
}
