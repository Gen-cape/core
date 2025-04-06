{
  config,
  lib,
  pkgs,
  inputs,
  inputs',
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf;
  inherit (lib.types) enum;

  cfg = config.core.gpu;
in {
  options.core.gpu = {
    type = mkOption {
      type = enum ["amd" "nvidia"];
      description = "The type of GPU the host system uses.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.type == "amd") {
      # hardware.amdgpu.opencl.enable = true;
      services.xserver.videoDrivers = ["modesetting"];

      # boot = {
      #   initrd.kernelModules = ["amdgpu"];
      #   kernelModules = ["kvm-amd"];
      # };

      # environment.systemPackages = [
      #   inputs'.chaotic.legacyPackages.mesa_git
      # ];

      # chaotic.mesa-git.enable = true;

      # Vulkan and opengl stuff
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          # package = inputs'.chaotic.packages.mesa_git.drivers;
          #
          extraPackages = with pkgs; [
            # vaapiVdpau
            # libvdpau-va-gl
            inputs.chaotic.packages."${pkgs.system}".libdrm_git
            # libva
            # rocmPackages.clr
            # rocmPackages.clr.icd
            # rocmPackages.rocminfo
            # rocmPackages.rocm-runtime
          ];

          extraPackages32 = with pkgs; [
            # driversi686Linux.libvdpau-va-gl
          ];
        };
        amdgpu.initrd.enable = lib.mkDefault true;
      };

      # environment.variables = {
      #   VDPAU_DRIVER = "radeonsi";
      #   LIBVA_DRIVER_NAME = "radeonsi";
      #   AMD_VULKAN_ICD = "RADV";
      #   OCL_ICD_VENDORS = "${pkgs.rocmPackages.clr.icd}/etc/OpenCL/vendors";
      #   VK_ICD_FILENAMES = "${inputs'.chaotic.packages.mesa_git.drivers.drivers}/share/vulkan/icd.d/radeon_icd.x86_64.json";
      # };

      # systemd.tmpfiles.rules = [
      #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      # ];
    })

    (mkIf (cfg.type == "nvidia") {
      services.xserver.videoDrivers = ["nvidia"];

      hardware = {
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
          # package = config.boot.linuxKernel.packages.linux_zen.nvidia_x11_vulkan_beta;
          package = (pkgs.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.stable;
        };

        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };

      boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"]; # For correct suspention and hibernation
    })
  ];
}
