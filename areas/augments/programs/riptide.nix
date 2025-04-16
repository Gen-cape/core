{inputs', ...}: {
  environment.systemPackages = [
    inputs'.riptide.packages.jj-fzf
  ];
}
