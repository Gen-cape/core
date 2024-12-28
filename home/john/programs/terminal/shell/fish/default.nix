{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    grc
  ];
  programs.fish = {
    enable = true;

    #pathAdd = with pkgs; [
    #  eza
    #  bat
    #  fzf
    #  ripgrep
    #  zoxide
    #  direnv
    #  fd
    #  file
    #];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = let
      plug = name: {
        name = "${name}";
        src = pkgs.fishPlugins.${name}.src;
      };
    in [
      (plug "grc")
      (plug "fzf-fish")
      (plug "hydro")
      (plug "z")
      (plug "fifc")
      (plug "done")
      (plug "bass")
      (plug "sponge")
      (plug "pisces")
      (plug "puffer")
      (plug "clownfish")
      (plug "fifc")
      #(plug "async-prompt")

      #{
      #  name = "grc";
      #  src = pkgs.fishPlugins.grc.src;
      #}
      #{
      #  name = "fzf";
      #  src = pkgs.fishPlugins.fzf-fish.src;
      #}
      #{
      #  name = "hydro";
      #  src = pkgs.fishPlugins.hydro.src;
      #}
      #{
      #  name = "z";
      #  src = pkgs.fishPlugins.z.src;
      #}
      #{
      #  name = "fifc";
      #  src = pkgs.fifc.src;
      #}
    ];
  };
  home.file.".config/fish/functions/fish_prompt.fish".source = ./prompt.fish;
}
