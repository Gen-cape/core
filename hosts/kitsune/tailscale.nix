{config, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    openFirewall = true;
    extraUpFlags = [
      "--advertise-exit-node"
    ];
  };

  environment.systemPackages = [
    config.services.tailscale.package
  ];

  networking.firewall = {
    trustedInterfaces = [config.services.tailscale.interfaceName];
    allowedTCPPorts = [config.services.tailscale.port];
  };
}
