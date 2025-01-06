{pkgs, ...}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  command = "Hyprland";
  tuiTheme = ''time=lightred;input=red'';
  ly = pkgs.ly;
in {
  security.pam.services = let
    settings = {
      enableGnomeKeyring = true;
    };
  in {
    login = settings;
    greetd = settings;
    tuigreet = settings;
    ly = settings;
  };

  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${tuigreet} --asterisks --asterisks-char \"█\" --theme '${tuiTheme}' --time --remember --remember-session --cmd ${command}";
        user = "greeter";
      };
    };
  };

  services.displayManager.ly = {
    enable = true;
    package = ly;
    settings = {
      hide_borders = true;
      save = true;
      login_cmd = command + ''exec "$@"'';
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
