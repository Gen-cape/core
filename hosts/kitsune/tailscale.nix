{
  config,
  pkgs,
  ...
}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    openFirewall = true;
    extraUpFlags = [
      "--advertise-exit-node"
    ];
    interfaceName = "userspace-networking";
  };

  environment.systemPackages = [
    config.services.tailscale.package

    pkgs.ethtool
    pkgs.networkd-dispatcher
  ];

  networking.firewall = {
    trustedInterfaces = [config.services.tailscale.interfaceName];
    allowedTCPPorts = [config.services.tailscale.port];
    allowedUDPPorts = [config.services.tailscale.port]; # Use the dynamic Tailscale port
  };

  # Configure networkd-dispatcher to set UDP GRO settings on boot
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = ["routable"];
      script = ''
        ${pkgs.ethtool}/bin/ethtool -K ens1 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };
}
