{pkgs, ...}: {
  home.packages = [
    pkgs.fzf
    pkgs.grc
    pkgs.fd
  ];
  programs.fish = {
    enable = true;

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
