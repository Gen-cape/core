{
  config,
  pkgs,
  inputs',
  ...
}: {
  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["v4l2loopback"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    kernelPackages = inputs'.chaotic.legacyPackages.linuxPackages_cachyos;
  };

  services.scx.enable = true;
}
