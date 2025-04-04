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
    "${selfPath}/home/john/ghostty";
}
