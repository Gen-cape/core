{...}: {
  programs.fish.shellAliases = {
    mkcd = "function _mkcd; mkdir -p $argv[1]; and cd $argv[1]; end; _mkcd";
  };
}
