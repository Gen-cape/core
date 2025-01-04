{inputs, ...}: {
  imports = [inputs.nix-index-db.hmModules.nix-index];

  config = {
    home.sessionVariables = {
      # auto-run programs using nix-index-database
      NIX_AUTO_RUN = "1";
    };

    programs = {
      nix-index-database.comma.enable = true;
      command-not-found.enable = false; # no nix-channel, using nix-index
      nix-index = {
        enable = true;
        symlinkToCacheHome = true;
      };
    };
  };
}
