{...}: {
  programs.tofi = {
    enable = true;
    settings = {
      #Window
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      #padding-left = "35%";
      padding-left = "25%";
      padding-top = "35%";
      result-spacing = 20;
      num-results = 5;
      # Font
      font = "JetBrainsMonoNerdFontMono";
      Font-size = 18;

      # Colors
      background-color = "#000A";
      # Catppuccin Mocha
      text-color = "#cdd6f4";
      prompt-color = "#f38ba8";
      selection-color = "#a6d189";

      # Options
      fuzzy-match = true;
      drun-launch = true;
      hide-cursor = true;
      prompt-text = "Bartender! Can I have a";
      prompt-padding = 15;
    };
  };
}
