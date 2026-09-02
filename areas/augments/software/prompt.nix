{
  programs.starship = {
    enable = true;

    settings = {
      scan_timeout = 2;
      command_timeout = 2000;
      add_newline = false;
      line_break.disabled = false;

      format = " $hostname$username$directory$shell$nix_shell$git_branch$git_commit$git_state$git_status$jobs$cmd_duration\n$character";

      hostname = {
        ssh_only = true;
        format = " @[$hostname](bold blue) ";
      };

      character = {
        error_symbol = "[](bold red)";
        success_symbol = "[󰗢](bold green)";
        vicmd_symbol = "[](bold yellow)";
        format = " $symbol [|](bold bright-black) ";
      };

      username.format = "[$user]($style) in ";

      directory = {
        format = "[ ](bold green) [$path]($style) ";
        substitutions = {
          "~/Dev" = "Dev";
          "~/Documents" = "Docs";
        };
      };
    };
  };
}
