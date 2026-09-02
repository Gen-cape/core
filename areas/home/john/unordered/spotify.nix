{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = let
    spicetifyPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    spotifyPackage = pkgs.spotify;

    theme = {
      name = "Blackout";
      src = "${pkgs.fetchFromGitHub {
        owner = "spicetify";
        repo = "spicetify-themes";
        rev = "a9ce22b3d3df303d994974b746c839c7d0907101";
        sha256 = "sha256-HQJrCB5kN8mE4yzC6Sc0Dh7mpttoAGIx3cvlNGnkPvc=";
      }}/Blackout";
    };
    colorScheme = "def";

    enabledExtensions = with spicetifyPkgs.extensions; [
      shuffle
      fullAlbumDate
      showQueueDuration
      history
      hidePodcasts
      playNext
      volumePercentage
    ];

    enabledCustomApps = with spicetifyPkgs.apps; [
      lyricsPlus
      ncsVisualizer
    ];
  };
}
