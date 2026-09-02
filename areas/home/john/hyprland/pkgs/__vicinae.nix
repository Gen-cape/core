{
  pkgs,
  inputs',
  ...
}: let
  fresh = inputs'.fresh.legacyPackages;
  vicinae = fresh.vicinae;
in {
  home.packages = [vicinae];

  systemd.user.services.vicinae = {
    Unit.Description = "Vicinae server service.";
    Install.WantedBy = ["default.target"];
    Service = {
      Restart = "always";
      RestartSec = 5;
      ExecStart = "${vicinae}/bin/vicinae server";
    };
  };

  xdg.configFile."vicinae/vicinae.json" = {
    source = ./vicinae.json;
    force = true;
  };

  home.file.".local/share/vicinae/themes/catppuccin-mocha.toml".source =
    ./catppuccin-mocha.toml;
}
