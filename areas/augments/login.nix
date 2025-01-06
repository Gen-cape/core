{pkgs, ...}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  command = "Hyprland";
in {
  security.pam.services = let
    settings = {
      enableGnomeKeyring = true;
    };
  in {
    login = settings;
    greetd = settings;
    tuigreet = settings;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --asterisks --asterisks-char \"]\" --time --remember --remember-session --cmd ${command}";
        user = "greeter";
      };
    };
  };

  # this is a life saver. ?
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
