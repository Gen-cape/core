{inputs', ...}: {
  environment.systemPackages = [
    inputs'.riptide.packages.jj-fzf
    inputs'.riptide.packages.toml-bombadil
  ];
}
