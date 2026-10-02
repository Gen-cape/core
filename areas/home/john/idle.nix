{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof noctalia-lock || noctalia-shell --lock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "mangoctl output * dpms on";
      };

      listener = [
        # Dim screen / reduce brightness
        {
          timeout = 150; # 2.5 min
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        # Lock session
        {
          timeout = 300; # 5 min
          on-timeout = "loginctl lock-session";
        }
        # Turn off display (DPMS)
        {
          timeout = 330; # 5.5 min
          on-timeout = "mangoctl output * dpms off";
          on-resume = "mangoctl output * dpms on";
        }
        # Suspend to RAM
        {
          timeout = 600; # 10 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
