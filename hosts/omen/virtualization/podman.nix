{pkgs, ...}: let
in {
  virtualisation.podman = {
    enable = true;
    # dockerCompat = true;
  };

  environment.systemPackages = [
    pkgs.distrobox
    pkgs.git
  ];
}
