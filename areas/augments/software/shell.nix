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
      j = "just";
      g = "just -g";

      switch = "nh os switch ${flakeDir}";
      boot-switch = "nh os boot ${flakeDir} && reboot";
      upd = "nix flake update --flake ${flakeDir}";
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.git.enable = true;
}
