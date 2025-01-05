{lib, ...}: {
  # services.hypridle.settings.listener = lib.mkForce [
  #   {
  #     timeout = 600;
  #     on-timeout = "hyprlock";
  #   }
  #   {
  #     timeout = 900;
  #     on-timeout = "systemctl suspend";
  #   }
  # ];
  #
  # hyprlock = {
  #   enable = true;
  #   scale = 1.5;
  # };
}
