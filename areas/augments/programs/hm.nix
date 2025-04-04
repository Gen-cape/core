{pkgs, ...}: {
  # programs.home-manager.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
