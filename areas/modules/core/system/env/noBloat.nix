{
  pkgs,
  lib,
  ...
}: {
  environment = {
    #defaultPackages = lib.mkForce [];

    systemPackages = with pkgs; [
      curl
      wget
      git
    ];
  };
}
