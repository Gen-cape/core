{
lib,
config,
pkgs,
...
}: let
  inherit (lib.modules) mkForce mkIf;
  cfg = config.modules.system.sound;
in {
  # almost identical to section in rafs config, tested, works great
  config = mkIf (cfg.enable) {
    users = {
      users."${config.modules.system.mainUser}".extraGroups = ["audio"];
      groups.audio = {};
    };
    # realtime priorities
    security.rtkit.enable = mkForce config.services.pipewire.enable;
    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = 99;
      }
      {
        domain = "@audio";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@audio";
        type = "-";
        item = "nice";
        value = -11;
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "524288";
      }
    ];

    services.udev.extraRules = ''
      KERNEL=="cpu_dma_latency", GROUP="audio"
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
    '';

    # fallback
    hardware.pulseaudio.enable = !config.services.pipewire.enable;
  };
}
