{inputs', ...}: {
  home.packages = [
    inputs'.riptide.packages.sttt
    inputs'.riptide.packages.jujutsu-fzf
    inputs'.riptide.packages.drvinter
    inputs'.riptide.packages.tmsufolders
    inputs'.riptide.packages.tmsufs

    inputs'.riptide.packages.ghostty
  ];
}
