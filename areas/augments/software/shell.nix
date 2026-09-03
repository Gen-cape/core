{pkgs, ...}: let
  flakeDir = "~/core";
in {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";

      v = "nvim";
      "v." = "nvim .";
      vc = "nvim ~/core/";

      ya = "yazi";
      ls = "eza";

      jl = "jj log -r :: --no-pager --limit 20";
      jk = "jj-fzf";
      cd = "z";

      switch = "nh os switch ${flakeDir}";
      boot-switch = "nh os boot ${flakeDir} && reboot";
      upd = "nix flake update --flake ${flakeDir}";
    };
  };
  environment.etc."fish/functions/mkcd.fish".text = ''
    function mkcd
      mkdir -p $argv[1]
      and cd $argv[1]
    end
  '';

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    eza
    comma
    killall
  ];
}
