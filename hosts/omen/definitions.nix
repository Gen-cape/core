_: let
in {
  config.core = {
    gpu.type = "nvidia";
    cpu.type = "amd";
    swapFile.enable = true;
    batteryThreshold.enable = true;
    batteryThreshold.value = 80;
    powerManagement.enable = true;
    # webcam = "worky";
    webcam = "noworky>:(";
    scaling = "1.0";
    boot = {enable = false;};
  };
}
