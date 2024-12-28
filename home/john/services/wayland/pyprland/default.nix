{pkgs, ...}: {
  home.packages = [pkgs.pyprland];
  home.file.".config/hypr/pyprland.toml".text =
    /*
    toml
    */
    ''
      [pyprland]
      plugins = ["scratchpads", "magnify"]

      [scratchpads.term]
      command = "ghostty --class=scratchpad"
      margin = 50
    '';
}
