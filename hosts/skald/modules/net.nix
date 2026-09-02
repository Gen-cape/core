{pkgs, ...}: {
  networking = {
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "1.0.0.1"];

    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 9993 25565]; # 25565: Minecraft
      allowedUDPPorts = [34197]; # 34197: Factorio
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };

  # Amnezia VPN
  programs.amnezia-vpn = {
    enable = true;
    package = pkgs.amnezia-vpn;
  };

  # Zapret DPI Bypass
  services.zapret = {
    enable = false;
    params = [
      "--dpi-desync=fakedsplit"
      "--dpi-desync-ttl=8"
      "--dpi-desync-split-pos=method+2"
    ];
  };
}
