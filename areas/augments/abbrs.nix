{pkgs, ...}: let
  templateDir = "~/riptide";
  flakeDir = "~/constructed-core";
in {
  environment.systemPackages = with pkgs; [
    eza
  ];
  programs.fish.shellAbbrs = {
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";

    "v" = "nvim";
    "v." = "nvim .";

    "vc" = "nvim ~/constructed-core/";
    "vv" = "nvim ~/neovim/";
    "ya" = "yazi";
    "pkg" = "nix-search-tv print | tv";
    "pkgs" = "nix run github:3timeslazy/nix-search-tv print | , tv";

    ls = "eza";

    jl = "jj log -r :: --no-pager --limit 20";
    jjk = "jj new -m \"FEAK PICTION, ABSOULTE CINEMA\"";

    flrc = "echo \"use flake\" > .envrc";
    pyFlake = "nix flake init -t ${templateDir}#pip && echo \"use flake\" > .envrc && direnv allow ";
    rFlake = "nix flake init -t ${templateDir}# && echo \"use flake\" > .envrc && direnv allow ";
    rfl = "nix flake init -t ${templateDir}# && echo \"use flake\" > .envrc && direnv allow ";

    breb = "nh os boot && nh home switch && reboot";

    rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
    upd = "nix flake update ${flakeDir}";
    upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

    hms = "home-manager switch --flake ${flakeDir}";
  };
}
