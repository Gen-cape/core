{
  lib,
  inputs,
  self,
  pkgs,
  inputs',
  hostname,
  ...
}: let
  inherit (lib) mkIf optionals concatLists;

  selfPath = (builtins.unsafeDiscardStringContext "${self}") + "/areas";
  scaling = "1.6";
  # debug = false;
  system = pkgs.system;
  debug = true;
  mod = "SUPER";
  funny = pkgs.callPackage ./pkgs/__funny.nix {};
  recordingScripts = pkgs.callPackage ./pkgs/__record.nix {};
  reload_script = pkgs.callPackage ./pkgs/__reload.nix {};
  audioScripts = pkgs.callPackage ./pkgs/__audio_test.nix {};
in {
  config = {
    home.packages = with pkgs; [
      kdePackages.xwaylandvideobridge # xwaylandvideobridge
      rofi-wayland
      # inputs'.hyprcursor.packages.hyprcursor
      inputs'.hyprland-contrib.packages.grimblast
      inputs'.hyprland-contrib.packages.hdrop
      inputs'.hyprland-contrib.packages.scratchpad
      inputs'.hyprpicker.packages.hyprpicker
      inputs'.hyprscratch.packages.default

      swww
      wluma
      grim
      wl-clipboard
      slurp
      waybar
      hypridle
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.hyprland;
      xwayland.enable = true;

      systemd = {
        enable = true;
        variables = ["--all"];
      };

      settings = {
        "$mainMod" = "SUPER";
        "$MOD" = "SUPER";

        monitor = ",preferred,auto,${scaling}";

        exec-once = [
          "swww-daemon"
          "sleep 1 && swww img ~/wall.gif"
          "hyprctl setcursor Bibata-Modern-Classic 20"
          # "env DRI_PRIME=1 firefox-nightly"
          "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
          "waybar"
          "wluma"
          "hypridle"
          "systemctl --user start opentabletdriver.service"
          "pypr"
          "hyprscratch init"
          "swaync"
          "bombadil watch -p bundle"
          # "kanata -c ${selfPath}/external/kanata/kanata.kdb -c ${selfPath}/external/kanata/kanata-zippy.kdb"
          "kanata -c ~/.config/kanata/kanata.kdb -c ~/.config/kanata/kanata-zippy.kdb"
        ];

        misc = {
          focus_on_activate = true;
          force_default_wallpaper = -1;
          vrr = 1;
          vfr = true;
          # Disable redundant renders
          disable_hyprland_logo = true; # wallpaper covers it anyway
          disable_splash_rendering = true; # "

          # Window swallowing
          # (i.e. children window causes parent to be hidden)
          enable_swallow = true; # Enable window swallowing
          swallow_regex = "^(Alacritty|kitty|foot|thunar|nemo|wezterm|scratch_term)"; # Windows for which swallowing is applied

          # dpms
          mouse_move_enables_dpms = true; # Enable DPMS on mouse/touchpad action
          key_press_enables_dpms = true; # Enable DPMS on keyboard action
          disable_autoreload = true; # Autoreload is unnecessary on NixOS, because the configuration file is read-only link
        };
        xwayland.force_zero_scaling = true;

        env = concatLists [
          [
            "XDG_SESSION_TYPE, wayland"
            "GDK_BACKEND, wayland,x11"
            # "SDL_VIDEODRIVER, wayland"
            "CLUTTER_BACKEND, wayland"
            "QT_QPA_PLATFORM, wayland;xcb"
            # "HYPRCURSOR_THEME, rose-pine-hyprcursor"
            # "HYPRCURSOR_SIZE,30"

            "GDK_SCALE, ${scaling}"

            "XDG_CURRENT_DESKTOP, Hyprland"
            "XDG_SESSION_DESKTOP, Hyprland"
          ]
          (optionals debug [
            "HYPRLAND_LOG_WLR, 1"
            "HYPRLAND_TRACE, 1"
          ])
          [
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
            "CLUTTER_BACKEND,wayland"
            "GDK_BACKEND,wayland,x11"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "QT_QPA_PLATFORM,wayland"
            "QT_QPA_PLATFORMTHEME,qt5ct"
            "QT_SCALE_FACTOR,1"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            #"SDL_VIDEODRIVER,wayland,x11"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "NIXOS_OZONE_WL,1"
            "MOZ_ENABLE_WAYLAND,1"
          ]
          (optionals (inputs.self.nixosConfigurations.${hostname}.config.core.gpu.type == "nvidia") [
            "LIBVA_DRIVER_NAME,nvidia"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
          ])
        ];

        layerrule = [
          # "noanim,^(selection)$"
        ];

        input = {
          sensitivity = 0.6;
          # keyboard layout
          kb_layout = "us,ru";
          kb_options = "grp:win_space_toggle";
          repeat_rate = 60;
          repeat_delay = 200;
          numlock_by_default = true;
          left_handed = false;
          follow_mouse = true;
          float_switch_override_focus = false;
          touchpad.natural_scroll = "yes";
          touchpad.scroll_factor = 0.422;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 4;
            passes = 4;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
            vibrancy = 0.1696;
            noise = 0.026;
            # contrast = 1;
            # vibrancy_darkness = 0.11;
            # vibrancy = 0.22;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            # color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master.new_status = "master";

        gestures = {
          workspace_swipe = false;
          # workspace_swipe = true;
          # workspace_swipe_forever = true;
        };
        bind = [
          # "$mainMod, Q, exec, foot"
          ''$MOD,RETURN,exec,run-as-service $(ghostty --gtk-single-instance=true)'' # terminal
          ''$mainMod, b, exec, hyprscratch btop "[float;size 70% 80%;center] alacritty --title btop -e btop" eager''
          ''$MODSHIFT, e, exec, hyprscratch yazi "[float;size 70% 80%;center] alacritty --title yazi -e yazi" eager''
          ''$mainMod, e, exec, hyprscratch yazi "[float;size 70% 80%;center] ghostty -e \"EDITOR=nvim yazi\"" eager''
          ''$mainMod, z, exec, hyprscratch ghostty "[float;size 70% 80%;center] ghostty" eager''
          ''$mainMod, bracketleft, exec, hyprscratch ghostty "[float;size 70% 80%;center] ghostty -e tray-tui" eager''

          # Ghostty Terminal Quake-style Bindings

          # Add these lines to your Hyprland config file (usually ~/.config/hypr/hyprland.conf)

          # Alacritty Terminal Quake-style Bindings
          ''$mainMod, grave, exec, hdrop -f -p top -w 100 -h 40 -g 0 -c alacritty_top alacritty --class alacritty_top        '' # Top terminal (grave/tilde key)
          ''$mainMod, left, exec, hdrop -f -p left -w 40 -h 100 -g 0 -c alacritty_left alacritty --class alacritty_left      '' # Left terminal
          ''$mainMod, right, exec, hdrop -f -p right -w 40 -h 100 -g 0 -c alacritty_right alacritty --class alacritty_right  '' # Right terminal
          ''$mainMod, down, exec, hdrop -f -p bottom -w 100 -h 40 -g 0 -c alacritty_bottom alacritty --class alacritty_bottom'' # Bottom terminal
          ''$mainMod, c, exec, hdrop -f -p top -w 70 -h 70 -g 15 -c alacritty_center alacritty --class alacritty_center      '' # Center terminal

          ''$MODSHIFT,RETURN,exec,ghostty -e "sttt doom -d 0.3  -b .8,.3,.87,.47 -c 9; exec fish"'' # terminal
          "$MODSHIFT,Q,killactive," # kill focused window
          "$MOD,T,togglegroup," # group focused window
          "$MODSHIFT,G,changegroupactive," # switch within the active group
          ''$MOD,R,exec, killall tofi || run-as-service $(tofi-drun)'' # alternative app launcher

          "$mainMod, C, killactive,"
          # "$mainMod, M, exit," # Im quite annoyed by this button sometimes, mayble ill return it later
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, J, togglesplit," # dwindle
          "$mainMod, F, fullscreen"
          ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
          "$mainMod, Print, exec, grim"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Replay buffer controls
          "$mainMod ALT, R, exec, ${recordingScripts.start-replay}/bin/start-replay"
          "$mainMod ALT, S, exec, ${recordingScripts.save-replay}/bin/save-replay"
          "$mainMod ALT, X, exec, ${recordingScripts.stop-recording}/bin/stop-recording"

          # Regular recording controls
          "$mainMod SHIFT, R, exec, ${recordingScripts.start-recording}/bin/start-recording"
          "$mainMod CTRL, R, exec, ${recordingScripts.start-recording-60}/bin/start-recording-60"
          "$mainMod SHIFT, X, exec, ${recordingScripts.stop-recording}/bin/stop-recording"
          "$mainMod SHIFT, P, exec, ${recordingScripts.toggle-pause-recording}/bin/toggle-pause-recording"

          # Funny
          "$mainMod ALT, P, exec, ${funny.spread-propaganda}/bin/spread-propaganda"

          ''$mainMod ALT, 1, exec, ${audioScripts.play-audio-to-mic}/bin/play-audio-to-mic $HOME/audio_1.mp3 50''
          ''$mainMod ALT, 2, exec, ${audioScripts.play-audio-to-mic}/bin/play-audio-to-mic $HOME/audio_2.mp3 50''
          ''$mainMod ALT, 3, exec, ${audioScripts.play-audio-to-mic}/bin/play-audio-to-mic $HOME/audio_3.mp3 50''
          ''$mainMod ALT, 4, exec, ${audioScripts.play-audio-to-mic}/bin/play-audio-to-mic $HOME/audio_4.mp3 50''
          ''$mainMod ALT, 5, exec, ${audioScripts.play-audio-to-mic}/bin/play-audio-to-mic $HOME/audio_5.mp3 50''

          # Stop audio playback
          ''bind = $mainMod ALT, 0, exec, ${pkgs.procps}/bin/pkill mpv''

          # "$mainMod ALT, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
          "$mainMod ALT, L, exec, ${pkgs.swaylock-effects}/bin/swaylock --daemonize"
          "$mainMod, W,  exec, pkill waybar || waybar"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
        # binde = [
        #   # volume controls
        #   ",XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
        #   ",XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"
        #
        #   # brightness controls
        #   '',XF86MonBrightnessUp,exec, brightnessctl -c backlight s 5%+''
        #   '',XF86MonBrightnessDown,exec, brightnessctl -c backlight s 5%-''
        # ];
        bindle = [
          ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5 --allow-boost --set-limit 200"
          ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5 --allow-boost --set-limit 200"
          ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight s 5%-"
          "SHIFT, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight s 0%"
          ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight s 5%+"
          "SHIFT, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight s 100%"
        ];

        # binds that are locked, a.k.a will activate even while an input inhibitor is active
        # bindl = [
        #   # media controls
        #   ",XF86AudioPlay,exec,playerctl play-pause"
        #   ",XF86AudioPrev,exec,playerctl previous"
        #   ",XF86AudioNext,exec,playerctl next"
        #
        #   ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        #   ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        # ];
        bindl = [
          "${mod}, O, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          "${mod}, C, exec, ${pkgs.playerctl}/bin/playerctl next"
          "${mod}, X, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"
        ];
      };
    };
  };
}
