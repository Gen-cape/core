{inputs', ...}: {
  home.packages = [
    inputs'.ghostty.packages.default
  ];
}
