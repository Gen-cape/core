{pkgs, ...}: {
  home.packages = [
    pkgs.fzf
    pkgs.grc
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
    ];
  };
}
