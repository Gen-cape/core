_: let
in {
  config.core = {
    gpu.type = "amd";
    cpu.type = "amd";
    swapFile.enable = true;
    batteryThreshold.enable = true;
    batteryThreshold.value = 80;
    powerManagement.enable = true;
    # webcam = "worky";
    webcam = "noworky>:(";
    scaling = "1.6";
    boot.grub.configurationLimit = 5;
  };
}
