{
  config,
  pkgs,
  lib,
  ...
}: let
  # (isx86Linux pkgs) -> true
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (builtins) toString;

  inherit (config) modules;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkBefore mkOptionDefault;

  mapOptionDefault = mapAttrs (_: mkOptionDefault);
  sys = modules.system;
  dev = modules.device;
in {
  config = mkIf (sys.sound.enable && dev.hasSound) {
    # Enable PipeWire sound server and additional emulation layers
    # for all kinds of backwards compatibility. Audio on Linux has
    # always been finicky, and this is the best way to ensure that
    # we have the best compatibility with the most software.
    services.pipewire = {
      enable = true;

      # use PipeWire as the primary sound server
      audio.enable = true;

      # Additional emulation layers to enable on top of PipeWire.
      # The backward compatibility provided by below options are impeccable and therefore
      # I choose to keep them. On a minimal system, they can (and probably should)
      # be omitted
      pulse.enable = true; # PulseAudio server emulation
      jack.enable = true; # JACK audio emulation
      alsa = {
        enable = true; # ALSA support
        support32Bit = isx86Linux pkgs; # if we're on x86 linux, we can support 32 bit
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };

    services.pipewire.wireplumber.enable = config.services.pipewire.enable;

    services.pipewire.extraConfig = {
      pipewire = {
        # Make PipeWire more verbose by default
        "10-logging" = {
          "context.properties"."log.level" = 3;
        };

        # <https://docs.pipewire.org/page_man_pipewire_conf_5.html>
        "10-defaults" = {
          "context.properties" = mapOptionDefault {
            "clock.power-of-two-quantum" = true;
            "core.daemon" = true;
            "core.name" = "pipewire-0";
            "link.max-buffers" = 16; # default is 64, is that really necessary?
            "settings.check-quantum" = true;
          };

          "context.spa-libs" = mapOptionDefault {
            "audio.convert.*" = "audioconvert/libspa-audioconvert";
            "avb.*" = "avb/libspa-avb";
            "api.alsa.*" = "alsa/libspa-alsa";
            "api.v4l2.*" = "v4l2/libspa-v4l2";
            "api.libcamera.*" = "libcamera/libspa-libcamera";
            "api.bluez5.*" = "bluez5/libspa-bluez5";
            "api.vulkan.*" = "vulkan/libspa-vulkan";
            "api.jack.*" = "jack/libspa-jack";
            "support.*" = "support/libspa-support";
            "video.convert.*" = "videoconvert/libspa-videoconvert";
          };
        };
      };

      pipewire-pulse = {
        # <https://docs.pipewire.org/page_man_pipewire-pulse_conf_5.html>
        "10-defaults" = {
          "context.spa-libs" = mapOptionDefault {
            "audio.convert.*" = "audioconvert/libspa-audioconvert";
            "support.*" = "support/libspa-support";
          };

          "pulse.cmd" = mkBefore [
            {
              cmd = "load-module";
              args = "module-always-sink";
              flags = [];
            }
          ];

          "pulse.properties" = {
            "server.address" = mkBefore ["unix:native"];
          };

          "pulse.rules" = mkBefore [
            {
              # skype does not want to use devices that don't have an S16 sample format.
              # we force the S16 format on the device to work around that
              matches = [
                {"application.process.binary" = "teams";}
                {"application.process.binary" = "teams-insiders";}
                {"application.process.binary" = "skypeforlinux";}
              ];

              actions.quirks = ["force-s16-info"];
            }
            {
              # firefox marks the capture streams as don't move and then they
              # can't be moved with pavucontrol or other tools.
              matches = singleton {"application.process.binary" = "firefox";};
              actions.quirks = ["remove-capture-dont-move"];
            }
            {
              # speech dispatcher asks for too small latency and then underruns.
              matches = singleton {"application.name" = "~speech-dispatcher*";};
              actions = {
                update-props = {
                  "pulse.min.req" = "1024/48000"; # 21ms
                  "pulse.min.quantum " = "1024/48000"; # 21ms
                };
              };
            }
          ];
        };
      };
    };
  };
}
