{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ripdrag
    pkgs.exiftool
    pkgs.zip
    pkgs.p7zip
    pkgs.trash-cli
    pkgs.fzf
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      opener = {
        edit = [
          {
            run = ''nvim "$@"'';
            block = true;
            for = "unix";
          }
        ];
      };
      open = {
        prepend_rules = [
          # Matches standard text files, source code, configs, and JSON/XML/scripts
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "application/x-subrip";
            use = "edit";
          }
          {
            mime = "application/*json";
            use = "edit";
          }
          {
            mime = "application/javascript";
            use = "edit";
          }
          {
            mime = "application/xml";
            use = "edit";
          }
          {
            mime = "application/x-yaml";
            use = "edit";
          }
          {
            mime = "application/toml";
            use = "edit";
          }
          {
            mime = "application/x-shellscript";
            use = "edit";
          }
        ];
      };
    };
  };
}
