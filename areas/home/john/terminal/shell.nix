{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    grc
    fd
  ];

  home.sessionVariables = {
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      enter_accept = false;
      inline_height = 40;
      style = "compact";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = ["--cmd cd"];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";

    plugins = let
      plug = name: {
        name = name;
        src = pkgs.fishPlugins.${name}.src;
      };
    in [
      (plug "grc")
      (plug "fzf-fish")
      (plug "fifc")
      (plug "done")
      (plug "bass")
      (plug "sponge")
      (plug "pisces")
      (plug "puffer")
      (plug "clownfish")
    ];
  };
}
