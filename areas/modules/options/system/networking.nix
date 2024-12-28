{lib, ...}: let
  inherit (lib.types) enum;
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules.system.networking = {
    nftables.enable = mkEnableOption "firewall";
    tarpit.enable = mkEnableOption "tarpit";
    optimizeTcp = mkEnableOption "TCP tweaks";

    wireless = {
      allowImperative = mkEnableOption "wpa cli management";
      backend = mkOption {
        type = types.enum ["iwd" "wpa_supplicant"];
        default = "wpa_supplicant";
      };
    };
  };
}
