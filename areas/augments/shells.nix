{
  lib,
  pkgs,
  ...
}: {
  config = {
    programs = {
      fish.enable = true;
      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
        loadInNixShell = true;
      };

      git = {
        enable = true;
        package = pkgs.gitMinimal;
      };

      nano.enable = true;

      bash.promptInit = ''
        eval "$(${lib.getExe pkgs.starship} init bash)"
      '';
    };
  };
}
