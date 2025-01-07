{
  pkgs,
  inputs,
  ...
}: {
  config = {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
    };
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #   ];
    #   config.common.default = "*";
    # };
    programs.xwayland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [
            "gtk"
          ];
        };
        hyprland = {
          default = [
            "hyprland"
          ];
        };
      };
    };
  };
}
