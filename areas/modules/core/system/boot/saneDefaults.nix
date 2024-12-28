{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce mkOverride mkMerge mkIf optionals;

  sys = config.modules.system.boot;
in {
  config = {
    boot = {
      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      tmp.cleanOnBoot = true;
      kernelPackages = mkOverride 500 sys.kernel;

      loader = {
        timeout = mkForce 1;

        generationsDir.copyKernels = true;

        efi.canTouchEfiVariables = true;
      };

      kernelParams = optionals sys.enableKernelTweaks [
        "fbcon=nodefer"
        "logo.nologo"

        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"

        "vt.global_cursor_default=0"
      ];
    };
  };
}
