{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types;
in {
  config = {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = false;
      };
      fish = {
        enable = true;
      };

      direnv = {
        enable = true;
        silent = true;
        nix-direnv = {
          enable = true;
        };
        loadInNixShell = true;
      };

      git = {
        enable = true;
        package = pkgs.gitMinimal;
      };

      nano.enable = true;

      bash = {
        promptInit = ''
          eval "$(${lib.getExe pkgs.starship} init bash)"
        '';
      };

      comma.enable = true;
    };
    environment.systemPackages = with pkgs; [
    ];
  };
}
