{config, ...}: {
  programs.waybar.settings.mainBar = {
    modules-left = ["hyprland/workspaces" "hyprland/submap"];

    "hyprland/submap" = {
      "format" = "<b>󰇘</b>";
      "max-length" = 8;
      "tooltip" = true;
    };

    #"hyprland/workspaces" = {
    #  format = "{icon}";
    #  on-click = "activate";
    #  all-outputs = true;
    #  format-icons = {
    #    "1" = "I";
    #    "2" = "II";
    #    "3" = "III";
    #    "4" = "IV";
    #    "5" = "V";
    #    "6" = "VI";
    #    "7" = "VII";
    #    "8" = "VIII";
    #    "9" = "IX";
    #    "10" = "X";
    #  };
    #};

    "hyprland/workspaces" = let
      hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
    in {
      on-click = "activate";
      on-scroll-up = "${hyprctl} dispatch workspace m+1";
      on-scroll-down = "${hyprctl} dispatch workspace m-1";
      format = "{icon}";
      active-only = false;
      all-outputs = true;
      show-special = false;
      format-icons = {
        "1" = "Ⅰ";
        "2" = "ⅠⅠ";
        "3" = "ⅠⅠⅠ";
        "4" = "ⅠⅤ";
        "5" = "Ⅴ";
        "6" = "ⅤⅠ";
        "7" = "ⅤⅠⅠ";
        "8" = "ⅤⅠⅠⅠ";
        "9" = "IX";
        "10" = "Ⅹ";
      };
    };
  };
}
