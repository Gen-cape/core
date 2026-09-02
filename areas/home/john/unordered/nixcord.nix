{inputs, ...}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    discord.vencord.enable = true;
    vesktop.enable = true;
    config = {
      useQuickCss = true;
      themeLinks = [];
      frameless = false;
      transparent = true;

      # plugins = {
      #   betterGifPicker.enable = true;
      #   fakeNitro.enable = true;
      #   youtubeAdblock.enable = true;
      #   alwaysTrust.enable = true;
      #   copyFileContents.enable = true;
      #   noF1.enable = true;
      #   showMeYourName.enable = true;
      #   unindent.enable = true;
      #   voiceDownload.enable = true;
      #   voiceMessages.enable = true;
      #   moreCommands.enable = true;
      #   moreKaomoji.enable = true;
      #   imageZoom.enable = true;
      #   webKeybinds.enable = true;
      # };
    };
  };
}
