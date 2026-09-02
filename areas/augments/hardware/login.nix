{pkgs, ...}: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      hide_borders = true;
      save = true;
      clock = "%H:%M:%S";
      box_title = "CONNECT TO SYSTEM";
      text_in_center = true;
      blank_box = true;
      asterisk = ">";
      login_cmd = "mango";
    };
  };

  # Automatically unlocks gnome-keyring on login if you use it
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
}
