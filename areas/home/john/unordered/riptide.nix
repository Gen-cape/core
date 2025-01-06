{inputs', ...}: {
  home.packages = [
    inputs'.riptide.packages.sttt
    inputs'.riptide.packages.jujutsu-fzf
  ];
}
