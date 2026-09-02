{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [
      "--rt"
      "--adaptive-sync"
      "--expose-wayland"
    ];
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  environment.systemPackages = [pkgs.mangohud];
}
