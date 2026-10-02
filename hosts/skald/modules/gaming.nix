{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [
      "--rt"
      "--adaptive-sync"
      "--expose-wayland"
    ];
  };

  programs.gamemode.enable = true;
  programs.gpu-screen-recorder.enable = true;
}
