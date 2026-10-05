# Disable welcome greeting
set -g fish_greeting

set -gx EDITOR nvim

zoxide init fish | source

# Hook Starship prompt
if type -q starship
    starship init fish | source
end

# Hook FZF (Ctrl+T for files, Alt+C for directory jump)
if type -q fzf
    fzf --fish | source
end

# Variables
set -l flakeDir ~/core

# Navigation & edit abbreviations
abbr -a .. 'cd ..'
abbr -a ... 'cd ../../'
abbr -a .... 'cd ../../../'

abbr -a v 'nvim'
abbr -a 'v.' 'nvim .'
abbr -a vc 'nvim ~/core/'

# Tools
abbr -a ya 'yazi'
abbr -a ls 'eza'
abbr -a jl 'jj log -r :: --no-pager --limit 20'
abbr -a jk 'jj-fzf'
abbr -a cd 'z'
abbr -a j 'just'
abbr -a g 'just -g'

# NixOS / Flake management
abbr -a switch "nh os switch $flakeDir"
abbr -a boot-switch "nh os boot $flakeDir && reboot"
abbr -a upd "nix flake update --flake $flakeDir"
