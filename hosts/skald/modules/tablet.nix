{pkgs, ...}: {
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
    package = pkgs.opentabletdriver;
  };
}
