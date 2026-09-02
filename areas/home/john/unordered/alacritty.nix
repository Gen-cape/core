{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.85;
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "none";
      };
    };
  };
}
