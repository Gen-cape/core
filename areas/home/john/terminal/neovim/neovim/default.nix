{
  inputs,
  pkgs,
  config,
  self,
  ...
}: {
  # programs.neovim = {
  #   enable = true;
  #
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  #
  #   withRuby = true;
  #   withPython3 = true;
  #   withNodeJs = true;
  # };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; let
    llvmPkgs = llvmPackages;
    fenixPkgs = inputs.fenix.packages.${pkgs.system};
  in [
    neovide

    (fenixPkgs.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-analyzer"
    ])

    python3
    python3Packages.pip
    pyright

    nodejs

    llvmPkgs.clang
    llvmPkgs.lldb
    llvmPkgs.clang-tools

    lua51Packages.lua
    luajitPackages.luarocks
    lua-language-server
    stylua

    go

    julia

    nixd

    fixjson

    typst
    tinymist
    typstyle

    shfmt

    vale
    mdformat

    gnumake
    tree-sitter
  ];

  home.file.".config/prettypst/prettypst.toml".text =
    # toml
    ''
      indentation = 2
      separate-label = true # insert space before a label
      final-newline = true # insert a final newline at the end

      [preserve-newline]
      content = true # preserve single newlines in markup
      math = true # preserve single newline in equations

      [block]
      long-block-style = "compact" # '[' and ']' on the same or separate lines as the content

      [term]
      space-before = false # insert a space before the ':' in terms
      space-after = true # insert a space after the ':' in terms

      [named-argument]
      space-before = false # insert a space before the ':' in named arguments
      space-after = true # insert a space after the ':' in named arguments

      [dictionary-entry]
      space-before = false # insert a space before the ':' in dictionary entries
      space-after = true # insert a space after the ':' in dictionary entries

      [import-statement]
      space-before = false # insert a space before the ':' in import statements
      space-after = true # insert a space after the ':' in import statements

      [comma]
      space-before = false # insert a space before the ',' in arguments
      space-after = true # insert a space after the ',' in arguments


      [columns]
      comma = "end-of-cell" # how to align commas in tables

      [heading]
      blank-lines-before = 2 # blank lines before a heading
      blank-lines-after = 1 # blank lines after a heading

      [columns-commands]
      grid = "columns"     # format the "grid", "gridx", ... command with
      gridx = "columns"    # columns specified by the named argument "columns"
      table = "columns"
      tablex = "columns"
    '';

  home.file.".config/vale/.vale.ini".text = ''
    StylesPath = .
    MinAlertLevel = suggestion
    [*]
    BasedOnStyles = Vale
  '';
}
