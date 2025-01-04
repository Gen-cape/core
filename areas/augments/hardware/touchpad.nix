{
  config.services.libinput = {
    enable = true;

    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
      middleEmulation = false;
    };

    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
  };
}
