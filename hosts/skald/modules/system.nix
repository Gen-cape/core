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
  programs.kdeconnect.enable = true;
}
