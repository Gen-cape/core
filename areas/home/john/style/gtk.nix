{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Sweet-Dark";
      package = lib.mkForce pkgs.sweet;
    };
    iconTheme = {
      name = "Sweet-Rainbow";
      package = pkgs.sweet-folders;
    };
  };
}
