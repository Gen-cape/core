{
  pkgs,
  lib,
  ...
}: let
  mainUser = "john";
  params = {
    controls = {
      hideCursor = true; # Set to true to hide cursor, REAL YAKUZA USE CONTROLLER
      hdrNits = 300; # HDR settings / fixes
    };
  };

  unclutterPkg = pkgs.unclutter-xfixes;

  steamGamescope = pkgs.writeShellScriptBin "steam-gamescope-session" ''
    #!/bin/bash
    # First, wait for the display to be fully initialized
    sleep 2
    # Set crucial environment variables
    export ENABLE_GAMESCOPE_WSI=1
    export ENABLE_HDR_WSI=1
    export DXVK_HDR=1
    # Get current screen resolution and refresh rate using xrandr
    DISPLAY_INFO=$(${pkgs.xorg.xrandr}/bin/xrandr | grep -E "^\S+ connected" | head -1)
    # Extract resolution
    RESOLUTION=$(echo "$DISPLAY_INFO" | grep -Po '\d+x\d+\+\d+\+\d+' | head -1 | grep -Po '\d+x\d+')
    if [ -z "$RESOLUTION" ]; then
      echo "Failed to detect resolution, using fallback 1920x1080"
      RESOLUTION="1920x1080"
    fi
    # Extract refresh rate - looks for the highest rate available
    REFRESH_RATE=$(${pkgs.xorg.xrandr}/bin/xrandr | grep -A 20 "^\S+ connected" | grep -Po '\d+\.\d+\*' | grep -Po '\d+\.\d+' | sort -rn | head -1)
    if [ -z "$REFRESH_RATE" ]; then
      echo "Failed to detect refresh rate, using fallback 120"
      REFRESH_RATE=120
    else
      # Round to nearest integer
      REFRESH_RATE=$(printf "%.0f\n" "$REFRESH_RATE")
    fi
    WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
    HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)
    echo "Detected screen: $WIDTH x $HEIGHT @ $REFRESH_RATE Hz"
    # Start unclutter to force hide the cursor if enabled
    if [ "${toString params.controls.hideCursor}" = "true" ]; then
      echo "Hiding cursor with unclutter"
      # Start unclutter with supported options
      ${unclutterPkg}/bin/unclutter --timeout 1 --jitter 100 &
      UNCLUTTER_PID=$!
      # Also set gamescope cursor hiding arguments for double protection
      CURSOR_ARGS="--force-grab-cursor --hide-cursor-delay 0"
    else
      echo "Cursor visible"
      CURSOR_ARGS=""
    fi
    # Function to kill unclutter when the script exits
    cleanup() {
      if [ -n "$UNCLUTTER_PID" ]; then
        echo "Killing unclutter"
        kill $UNCLUTTER_PID
      fi
      exit
    }
    # Set up cleanup on exit
    trap cleanup EXIT INT TERM

    # Additional X cursor hiding
    if [ "${toString params.controls.hideCursor}" = "true" ]; then
      # Use xsetroot to set an empty cursor
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name none
    fi

    # Launch Steam in gamescope with detected resolution and refresh rate
    ${pkgs.gamescope}/bin/gamescope \
      -w "$WIDTH" -h "$HEIGHT" \
      -W "$WIDTH" -H "$HEIGHT" \
      -r "$REFRESH_RATE" \
      --borderless \
      --fullscreen \
      --adaptive-sync \
      --hdr-enabled \
      --hdr-itm-enable \
      --hdr-itm-sdr-nits ${toString params.controls.hdrNits} \
      --hdr-sdr-content-nits ${toString params.controls.hdrNits} \
      $CURSOR_ARGS \
      -f -e \
      -- ${pkgs.steam}/bin/steam -tenfoot -gamepadui -fulldesktopres
  '';

  # Create a simple cursor hider utility
  cursorHider = pkgs.writeShellScriptBin "hide-cursor" ''
    #!/bin/sh
    # This is a standalone utility to hide the cursor
    ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name none
    exec ${unclutterPkg}/bin/unclutter --timeout 1
  '';

  # Create an X session entry for Steam Gamescope
  steamSessionDesktop = pkgs.writeTextFile {
    name = "steam-gamescope.desktop";
    destination = "/share/xsessions/steam-gamescope.desktop";
    text = ''
      [Desktop Entry]
      Name=Steam (Gamescope)
      Comment=Steam gaming session with Gamescope
      Exec=${steamGamescope}/bin/steam-gamescope-session
      Type=Application
    '';
  };

  # Create an invisible cursor theme
  invisibleCursorTheme = pkgs.runCommand "invisible-cursor-theme" {} ''
    mkdir -p $out/share/icons/invisible/cursors
    touch $out/share/icons/invisible/cursors/left_ptr
    echo "[Icon Theme]
    Name=invisible
    Comment=Invisible cursor theme
    Inherits=invisible" > $out/share/icons/invisible/index.theme
  '';
in {
  specialisation.steamgamescopeauto = {
    inheritParentConfig = true;
    configuration = {
      environment.etc."specialisation".text = "steamgamescopeauto";
      programs.steam.enable = true;
      hardware.opengl.enable = true;
      services.greetd.enable = lib.mkForce false;
      services.displayManager.ly.enable = lib.mkForce false;
      environment.systemPackages = [
        steamGamescope
        steamSessionDesktop
        cursorHider
        pkgs.gamescope
        pkgs.xorg.xrandr
        pkgs.xorg.xsetroot
        unclutterPkg
        invisibleCursorTheme
        pkgs.lightdm-mini-greeter
      ];

      # Configure LightDM for autologin
      services.xserver = {
        enable = true;
        displayManager = {
          lightdm = {
            enable = true;
            extraSeatDefaults = ''
              greeter-session=lightdm-mini-greeter
              user-session=steam-gamescope
              autologin-user=${mainUser}
              autologin-session=steam-gamescope
            '';
          };
          autoLogin = {
            enable = true;
            user = mainUser;
          };
          # Set as default
          defaultSession = "steam-gamescope";
          # Define our custom session
          session = [
            {
              manage = "desktop";
              name = "steam-gamescope";
              start = ''
                ${steamGamescope}/bin/steam-gamescope-session
                waitPID=$!
              '';
            }
          ];
        };
        # Add a server flag to disable hardware cursors globally
        serverFlagsSection = lib.mkIf params.controls.hideCursor ''
          Option "NoCursor" "true"
        '';
        # Configure X for cursor hiding
        displayManager.sessionCommands = lib.mkIf params.controls.hideCursor ''
          ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name none
          ${unclutterPkg}/bin/unclutter --timeout 1 &
        '';
      };
      # Add minimal greeter for LightDM
      environment.etc."lightdm/lightdm-mini-greeter.conf".text = ''
        [greeter]
        user = ${mainUser}
        show-password-label = true
        password-label-text = Password:
      '';

      # Configure unclutter-xfixes service
      services.unclutter = lib.mkIf params.controls.hideCursor {
        enable = false; # Disable this to avoid conflicts
      };

      services.xserver.updateDbusEnvironment = true;

      # Enable unclutter-xfixes service with safe options
      services.unclutter-xfixes = lib.mkIf params.controls.hideCursor {
        enable = true;
        timeout = 1;
      };

      # Set cursor environment variables
      environment.variables = lib.mkIf params.controls.hideCursor {
        XCURSOR_SIZE = "1";
        XCURSOR_THEME = "invisible";
        SDL_MOUSE_RELATIVE = "1";
        SDL_VIDEO_X11_DGAMOUSE = "1";
      };
    };
  };
}
