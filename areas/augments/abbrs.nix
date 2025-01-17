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

    ls = "eza";

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
