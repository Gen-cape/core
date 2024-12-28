{
  pkgs,
  config,
  inputs',
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs'.ghostty.packages.default
  ];
  #systemd.user.services = {
  #  shadowsocks-proxy = {
  #    Unit = {
  #      Description = "Local Shadowsocks proxy";
  #      After = "network.target";
  #    };
  #    Install = {
  #      WantedBy = ["default.target"];
  #    };
  #    Service = {
  #      ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c ${config.home.homeDirectory}/shadowsocks.json";
  #      ExecStop = "${pkgs.toybox}/bin/killall sslocal";
  #    };
  #  };
  #};
}
