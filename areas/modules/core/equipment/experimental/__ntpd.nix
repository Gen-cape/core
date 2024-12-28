{
  pkgs,
  lib,
  options,
  ...
}: {
  networking.timeServers = options.networking.timeServers.default ++ ["ntp.example.com"];
}
