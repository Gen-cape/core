{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = [
      # No events configured by default is fine
    ];
    timeouts = let
      std-lock-time = 300; # 5 minutes of idling
    in [
      {
        timeout = std-lock-time - 5; # 5 seconds before lock
        command = "notify-send 'Locking in 5 seconds!'"; # or logger to log the event in a logfile
      }
      {
        timeout = std-lock-time;
        command = "${pkgs.swaylock-effects}/bin/swaylock --daemonize";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      screenshots = true;
      indicator = true;
      effect-blur = "7x5";
      fade-in = "0.2";
      grace = 5;
      indicator-radius = "100";

      font = "Work Sans";
      show-failed-attempts = false;
      indicator-thickness = 20;
      separator-color = "00000000";
      effect-vignette = "0.5:0.5";
      line-uses-ring = false;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%d/%m/%Y";
      ignore-empty-password = true;
    };
  };
  security.pam.services.swaylock = {
  };
  security.pam.services.swaylock.fprintAuth = false;
}
# events = [
#   {
#     event = "before-sleep";
#     command = "${pkgs.swaylock-effects}/bin/swaylock --daemonize";
#   }
#   {
#     event = "lock";
#     command = "${pkgs.swaylock-effects}/bin/swaylock --daemonize --grace 0";
#   }
#   {
#     event = "unlock";
#     command = "pkill -SIGUSR1 swaylock";
#   }
#   {
#     event = "after-resume";
#     command = "swaymsg \"output * dpms on\"";
#   }
# ];

