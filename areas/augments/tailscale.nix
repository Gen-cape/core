{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = false;
    port = 41641;
    interfaceName = "tailscale0";
    extraUpFlags = [
      "--exit-node=100.102.0.99"
      "--exit-node-allow-lan-access=true"
    ];
  };

  environment.systemPackages = [pkgs.tailscale];
}
