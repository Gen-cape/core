{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf optionals concatLists;

  mod = "Mod4"; # SUPER

  funny = pkgs.callPackage ./pkgs/__funny.nix {};
  recordingScripts = pkgs.callPackage ./pkgs/__record.nix {};
  audioLite = pkgs.callPackage ./pkgs/__hijacker.nix {};
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    wluma
    hypridle
    brightnessctl
    pamixer
    playerctl
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Noctalia Shell Configuration & Autostart
  xdg.configFile."noctalia/config.toml".text = ''
    [bar]
    position = "top"
    height = 32

    [notifications]
    enabled = true
    timeout = 5000

    [scratchpads]
    # Native dropdown surfaces managed directly by Noctalia
    terminal = { command = "ghostty -e fish", position = "top", size = "40%" }
    yazi = { command = "ghostty -e yazi", position = "center", size = "70%" }
    btop = { command = "alacritty --title btop -e btop", position = "center", size = "70%" }
  '';

  # MangoWM Compositor Configuration
  xdg.configFile."mango/config.toml".text = ''
    # --- Monitors ---
    [output]
    name = "*"
    scale = 1.6
    mode = "preferred"

    # --- Autostart ---
    [startup]
    exec = [
      "systemctl --user import-environment PATH",
      "noctalia-shell",
      "wluma",
      "hypridle",
      "dotter watch",
      "kanata -c ~/.config/kanata/kanata.kdb -c ~/.config/kanata/kanata-zippy.kdb",
      "systemctl --user start opentabletdriver.service",
      "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
    ]

    # --- Input ---
    [input]
    sensitivity = 0.6
    repeat_rate = 50
    repeat_delay = 300
    left_handed = false

    [input.keyboard]
    layout = "us,ru"
    options = "grp:win_space_toggle"
    numlock = true

    [input.touchpad]
    natural_scroll = true
    scroll_factor = 0.422

    # --- Appearance & Layout ---
    [layout]
    type = "tiling"
    gaps_inner = 5
    gaps_outer = [12, 22, 22, 22]
    border_width = 2
    focus_follows_mouse = true

    # --- Window Rules ---
    [[rules]]
    app_id = "ghostty"
    title = "^scratch_term"
    floating = true
    geometry = { width = "80%", height = "85%", center = true }

    [[rules]]
    app_id = "float_term"
    floating = true
    center = true

    [[rules]]
    title = "^(Firefox — Sharing Indicator)$"
    hidden = true

    # --- Keybindings ---
    [keybinds]
    "f10" = "exec alacritty"
    "${mod}+Return" = "exec alacritty"
    "${mod}+q" = "close"
    "${mod}+v" = "toggle_floating"
    "${mod}+f" = "fullscreen"

    # Shell Integration & Scratchpads via Noctalia IPC
    "${mod}+grave" = "exec noctalia-ipc toggle-scratchpad terminal"
    "${mod}+e" = "exec noctalia-ipc toggle-scratchpad yazi"
    "${mod}+b" = "exec noctalia-ipc toggle-scratchpad btop"
    "${mod}+r" = "exec vicinae toggle"
    "${mod}+Shift+a" = "exec vicinae vicinae://extensions/vicinae/clipboard/history"

    # Navigation (Focus)
    "${mod}+Left" = "focus left"
    "${mod}+Right" = "focus right"
    "${mod}+Up" = "focus up"
    "${mod}+Down" = "focus down"

    # Workspace Management (1-10)
    ${builtins.concatStringsSep "\n" (map (i: ''
      "${mod}+${toString i}" = "workspace ${toString i}"
      "${mod}+Shift+${toString i}" = "move_to_workspace ${toString i}"
    '') (lib.range 1 9))}
    "${mod}+0" = "workspace 10"
    "${mod}+Shift+0" = "move_to_workspace 10"

    # Hardware & Media
    "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5 --allow-boost --set-limit 200"
    "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5 --allow-boost --set-limit 200"
    "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t"
    "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -c backlight s 5%+"
    "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -c backlight s 5%-"
    "${mod}+o" = "exec ${pkgs.playerctl}/bin/playerctl play-pause"
    "${mod}+c" = "exec ${pkgs.playerctl}/bin/playerctl next"
    "${mod}+x" = "exec ${pkgs.playerctl}/bin/playerctl previous"

    # Screen Capture
    "${mod}+Shift+s" = "exec ${pkgs.slurp}/bin/slurp -d | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy"
    "Print" = "exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"

    # Custom Scripts
    "${mod}+Alt+r" = "exec ${recordingScripts.start-replay}/bin/start-replay"
    "${mod}+Alt+s" = "exec ${recordingScripts.save-replay}/bin/save-replay"
    "${mod}+Alt+x" = "exec ${recordingScripts.stop-recording}/bin/stop-recording"
    "${mod}+Alt+p" = "exec ${funny.spread-propaganda}/bin/spread-propaganda"
    "${mod}+Alt+0" = "exec ${pkgs.procps}/bin/pkill pw-play"

    # Audio hijacker binds (1-9)
    ${builtins.concatStringsSep "\n" (map (num: ''
      "${mod}+Alt+${toString num}" = "exec ${audioLite}/bin/hijacker-lite ~/Sounds/${toString num}.mp3"
    '') (lib.range 1 9))}
  '';
  # In your home-manager config:
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof noctalia-lock || noctalia-shell --lock"; # or hyprlock / swaylock
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "mangoctl output * dpms on"; # wake display via MangoWM IPC
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
