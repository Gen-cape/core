{
  pkgs,
  lib,
  ...
} @ autoArgs: {
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      enter_accept = false;
      inline_height = 40;
      style = "compact";
    };
    flags = [
      "--disable-up-arrow"
      # "--disable-ctrl-r"
    ];
  };
  programs.nushell = {
    enable = true;
    shellAliases = import ./__nushellAbbrs.nix autoArgs;
    extraEnv =
      # nu
      ''
        $env.EDITOR = "/home/john/neovim/nvim/bin/nvim +star"
        $env.TERMINAL = "alacritty"
        $env.BROWSER = "zen"
        $env.PROMPT_INDICATOR = ""
        $env.PROMPT_INDICATOR_VI_INSERT = ""
        $env.PROMPT_INDICATOR_VI_NORMAL = " "
        $env.PROMPT_MULTILINE_INDICATOR = ""
      '';
    extraConfig =
      # nu
      ''
        $env.config = {
          show_banner: false,
          edit_mode: vi,
          keybindings: [
            {
                name: zoxide_jump
                modifier: alt
                keycode: char_z
                mode: [emacs, vi_normal, vi_insert]
                event: {
                    send: executehostcommand
                    cmd: "cd (zoxide query --interactive)"
              }
            }
            {
                name: old_pwd
                modifier: alt
                keycode: char_x
                mode: [emacs, vi_normal, vi_insert]
                event: {
                    send: executehostcommand
                    cmd: "cd -"
              }
            }
            {
              name: abbr
              modifier: control
              keycode: space
              mode: [emacs, vi_normal, vi_insert]
              event: [
              { send: menu name: abbr_menu }
              { edit: insertchar, value: ' '}
              ]
            }

            ]

          menus: [
            {
              name: abbr_menu
              only_buffer_difference: false
              marker: "👀 "
              type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
              }
              style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
              }
              source: { |buffer, position|
                scope aliases
                | where name == $buffer
                | each { |elt| {value: $elt.expansion }}
              }
            }

          ]
        }
      '';
  };
  home.packages = with pkgs; [
    nushellPlugins.skim
    skim
    neovim
  ];
}
