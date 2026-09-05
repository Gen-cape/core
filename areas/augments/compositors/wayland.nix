{
  pkgs,
  lib,
  ...
}: {
  # Force Electron/Chromium apps to run natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common.default = ["wlr" "gtk"];
      mango = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };

  systemd.user.services.xdg-desktop-portal.unitConfig = {
    Requisite = lib.mkForce [];
  };

  environment.systemPackages = with pkgs; [
    vesktop

    (discord.override {
      withOpenASAR = true;
    })
  ];
}
