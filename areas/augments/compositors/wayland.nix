{pkgs, ...}: {
  # Force Electron/Chromium apps to run natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["wlr" "gtk"];
  };
}
