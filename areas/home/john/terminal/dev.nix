{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    # Terminal UI & Tooling
    neovide
    gnumake
    tree-sitter
    shfmt
    fixjson
    nix-init

    # Languages & Toolchains
    python3
    python3Packages.pip
    pyright
    llvmPackages.clang
    llvmPackages.lldb
    llvmPackages.clang-tools
    lua51Packages.lua
    luajitPackages.luarocks
    lua-language-server
    stylua
    nixd

    # Typesetting & Documentation
    typst
    tinymist
    typstyle
    vale
    mdformat
  ];

  # Nix-Init Configuration
  xdg.configFile."nix-init/config.toml".text = ''
    commit = true
  '';

  # Vale Linter
  xdg.configFile."vale/.vale.ini".text = ''
    StylesPath = .
    MinAlertLevel = suggestion
    [*]
    BasedOnStyles = Vale
  '';

  # Prettypst Formatter
  xdg.configFile."prettypst/prettypst.toml".text = ''
    indentation = 2
    separate-label = true
    final-newline = true

    [preserve-newline]
    content = true
    math = true

    [block]
    long-block-style = "compact"

    [term]
    space-before = false
    space-after = true

    [named-argument]
    space-before = false
    space-after = true

    [dictionary-entry]
    space-before = false
    space-after = true

    [import-statement]
    space-before = false
    space-after = true

    [comma]
    space-before = false
    space-after = true

    [columns]
    comma = "end-of-cell"

    [heading]
    blank-lines-before = 2
    blank-lines-after = 1

    [columns-commands]
    grid = "columns"
    gridx = "columns"
    table = "columns"
    tablex = "columns"
  '';
}
