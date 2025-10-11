{pkgs, ...} @ autoArgs: {
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      enter_accept = false;
      inline_height = 40;
      style = "compact";
    };
    flags = [
      "--disable-up-arrow"
    ];
  };
}
