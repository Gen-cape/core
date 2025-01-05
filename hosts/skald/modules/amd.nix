{lib, ...}: {
  config = {
    services.xserver.videoDrivers = lib.mkDefault ["modesetting"];
    hardware.amdgpu.initrd.enable = lib.mkDefault true;
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
