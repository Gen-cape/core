_: let
in {
  config.core = {
    gpu.type = "amd";
    swapFile.enable = true;
    batteryThreshold.enable = true;
    batteryThreshold.value = 80;
  };
}
