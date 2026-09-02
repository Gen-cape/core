{
  config,
  pkgs,
  ...
}: {
  services.displayManager.noctalia-greeter = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    settings = {
      session.default = "mango";

      user.default = "john";

      keyboard.layout = "us";
      cursor.size = 20;
      appearance = {
        scheme = "Synced";
        password_style = "random";
        hide_logo = true;
      };
    };
  };

  # Automatically unlock gnome-keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
