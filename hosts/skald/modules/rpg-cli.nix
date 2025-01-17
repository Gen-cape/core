{
  programs.fish.shellAliases = {
    # Basic rpg function to change directory and interact with rpg-cli

    rpg = ''
        function rpg
          set -l mode (printf "Navigate\nBattle\nInventory\nQuest\nExit" | fzf --prompt="RPG Mode: " --height 40% --layout=reverse)

          switch $mode
              case "Navigate"
                  # Use find with error handling and sudo if needed
                  set -l selected_dir (find . -type d 2>/dev/null | grep -v -E '(/.git/|/node_modules/|/dist/)' | fzf --prompt="Select Directory: " --height 40% --layout=reverse)

                  if test -n "$selected_dir"
                      # Use try-catch like approach for directory change
                      if cd "$selected_dir" 2>/dev/null
                          rpg-cli cd -f .
                          echo "Navigated to: $selected_dir"
                      else
                          # If permission denied, try with sudo
                          echo "Permission denied. Attempting with sudo..."
                          if sudo cd "$selected_dir"
                              rpg-cli cd -f .
                              echo "Navigated to (with sudo): $selected_dir"
                          else
                              echo "Could not navigate to directory"
                          end
                      end
                  end

              case "Battle"
                  rpg-cli battle

              case "Inventory"
                  rpg-cli inventory | fzf --multi --prompt="Inventory: " --height 60% --layout=reverse

              case "Quest"
                  rpg-cli quests | fzf --prompt="Quests: " --height 60% --layout=reverse

              case "Exit"
                  return 0

              case '*'
                  echo "Invalid mode selected"
                  return 1
          end
      end; rpg
    '';

    # Override cd to include RPG interactions
    # cd = "function _cd; builtin cd $argv; rpg-cli cd -f .; rpg-cli battle; end; _cd";

    # Create dungeon levels conveniently
    dn = "function _dn; \
      set -l current (basename $PWD); \
      if string match -q -r '^[0-9]+$' $current; \
        set -l next (math $current + 1); \
        mkdir -p $next && cd $next && rpg-cli ls; \
      else if test -d 1; \
        cd 1 && rpg-cli ls; \
      else; \
        mkdir -p dungeon/1 && cd dungeon/1 && rpg-cli ls; \
      end; \
    end; _dn";

    # Override ls to search for chests
    ls = "function _ls; \
      command ls $argv; \
      if test (count $argv) -eq 0; \
        rpg-cli cd -f .; \
        rpg-cli ls; \
      end; \
    end; _ls";

    # Wrapper for file-modifying operations to require a battle
    rm = "rpg-cli cd -f . && rpg-cli battle && command rm";
    rmdir = "rpg-cli cd -f . && rpg-cli battle && command rmdir";
    mkdir = "rpg-cli cd -f . && rpg-cli battle && command mkdir";
    touch = "rpg-cli cd -f . && rpg-cli battle && command touch";
    mv = "rpg-cli cd -f . && rpg-cli battle && command mv";
    cp = "rpg-cli cd -f . && rpg-cli battle && command cp";
    chown = "rpg-cli cd -f . && rpg-cli battle && command chown";
    chmod = "rpg-cli cd -f . && rpg-cli battle && command chmod";
  };

  # Optional: Fish shell function to display RPG status in prompt
  # programs.fish.interactiveShellInit = ''
  #   function fish_prompt
  #     set -l rpg_status (rpg-cli stat --quiet)
  #     set -l rpg_plain (rpg-cli stat --plain)
  #
  #     # Customize the prompt to include RPG status
  #     printf '%s[%s]%s@%s > ' \
  #       (set_color blue) \
  #       "$rpg_status" \
  #       (set_color normal) \
  #       (prompt_pwd)
  #   end
  # '';
}
