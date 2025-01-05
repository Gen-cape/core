{
  inputs',
  config,
  self,
  ...
}: let
  selfPath = (builtins.unsafeDiscardStringContext "${self}") + "/areas";
in {
  home.packages = [
    inputs'.ghostty.packages.default
  ];
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink
    # "${selfPath}/areas/home/john/ghostty";
    "home/john/areas/home/john/ghostty";
}
