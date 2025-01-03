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
      horizontalScrolling = false;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
  };
}
