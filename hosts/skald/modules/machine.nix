{config, ...}: let
in {
  config.modules = {
    device = {
      cpu.type = "amd";
      gpu.type = "amd";
      hasBluetooth = true;
      hasSound = true;
      type = "laptop";
      # monitors = ["DP-1" "HDMI-A-1"];
      monitors = ["DP-1"];
    };
    system = {
      sound.enable = true;
      video.enable = true;
      bluetooth.enable = true;
      security.fixWebcam = false;
      mainUser = "john";
      #autoLogin = true;
    };
  };
}
