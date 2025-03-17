{
  config = {
    programs.zellij = {
      enable = false;
      settings = {
        copy_command = "wl-copy";

        auto_layouts = true;
        layout_dir = "${./layouts}";

        default_layout = "basic";

        on_force_close = "quit";
        pane_frames = true;
        session_serialization = false;

        ui.pane_frames = {
          rounded_corners = true;
          hide_session_name = true;
        };

        simplified-ui = true;

        # load internal plugins from built-in paths
        plugins = {
          tab-bar.path = "tab-bar";
          status-bar.path = "status-bar";
          strider.path = "strider";
          compact-bar.path = "compact-bar";
        };

        themes = {
          nord = {
            fg = "#D8DEE9";
            bg = "#2E3440";
            black = "#3B4252";
            red = "#BF616A";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            blue = "#81A1C1";
            magenta = "#B48EAD";
            cyan = "#88C0D0";
            white = "#E5E9F0";
            orange = "#D08770";
          };
        };

        theme = "nord";
      };
    };
  };
}
