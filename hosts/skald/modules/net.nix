{pkgs, ...}: {
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [25565];
      allowedUDPPorts = [34197];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.tailscale = {
    enable = false;
    useRoutingFeatures = "client";
  };

  programs.amnezia-vpn = {
    enable = true;
    package = pkgs.amnezia-vpn;
  };

  services.zapret = {
    enable = false;
    params = [
      "--dpi-desync=fakedsplit"
      "--dpi-desync-ttl=8"
      "--dpi-desync-split-pos=method+2"
    ];
  };
}
