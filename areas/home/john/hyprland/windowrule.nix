{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # float_term
      "float, class:float_term"
      "center, class:float_term"

      "float,sclass:^(scratchpad)"
      "size 80% 85%,class:^(scratchpad)"
      "workspace special silent,class:^(scratchpad)"
      "center,class:^(scratchpad)"

      "float,class:^(scratch_term)"
      "size 80% 85%,class:^(scratch_term)"
      "workspace special:scratch_term ,class:^(scratch_term)"
      "center,class:^(scratch_term)"
    ];
  };
}
