{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    NIX_AUTO_RUN = "1";
  };
  programs.fzf.enable = true;
}
