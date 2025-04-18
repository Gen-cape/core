{
  pkgs,
  lib,
  ...
}: let
  mainUser = "john";

  display = {
    width = 3200;
    height = 2000;
    refreshRate = 120;
    hdrNits = 300;
  };

  # Create a script to launch Steam in gamescope mode using parameters - fixes exposure
  steamGamescope = pkgs.writeShellScriptBin "steam-gamescope-session" ''
    #!/bin/sh
    # Set necessary environment variables for HDR
    export ENABLE_GAMESCOPE_WSI=1
    export ENABLE_HDR_WSI=1
    export DXVK_HDR=1
    # Launch gamescope with Steam
    exec ${pkgs.gamescope}/bin/gamescope \
      -W ${toString display.width} -H ${toString display.height} \
      -r ${toString display.refreshRate} \
      --hdr-enabled \
      --hdr-itm-enable \
      --hdr-itm-sdr-nits ${toString display.hdrNits} \
      --hdr-sdr-content-nits ${toString display.hdrNits} \
      -f -e \
      -- ${pkgs.steam}/bin/steam -tenfoot -gamepadui -fulldesktopres
  '';

  # Create an X session entry for our custom Steam/Gamescope session
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
in {
  specialisation.steamgamescopeauto = {
    inheritParentConfig = true;
    configuration = {
      programs.steam.enable = true;

      services.greetd.enable = lib.mkForce false;
      services.displayManager.ly.enable = lib.mkForce false;

      environment.systemPackages = [
        steamGamescope
        steamSessionDesktop
        pkgs.gamescope
        pkgs.lightdm-mini-greeter
      ];

      # Configure LightDM (a reliable display manager) for autologin
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
          # This is the most reliable way to configure autologin in NixOS
          autoLogin = {
            enable = true;
            user = mainUser;
          };
          # Specify our custom session
          defaultSession = "steam-gamescope";
          # Make our custom session available
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
      };

      # Add minimal greeter for LightDM
      environment.etc."lightdm/lightdm-mini-greeter.conf".text = ''
        [greeter]
        user = ${mainUser}
        show-password-label = true
        password-label-text = Password:
      '';
    };
  };
}
