{
  self,
  lib,
  inputs,
  ...
}: let
  inherit (inputs.riptide.mimics) getModulesFzf;
  inherit (lib.lists) concatLists;
  mod = requests: dropExpr:
    getModulesFzf {
      path = ./.;
      inherit requests;
      inherit dropExpr;
    };
in {
  imports = concatLists [
    # (mod ["/programs/ default.nix"] [])
    #(mod ["/packages/ default.nix"] [])
    #(mod ["/services/ default.nix"] ["clipboard" "ref" "dunst" "hyprpanel"])
    #(mod ["/themes/ default.nix"] [])
    #(mod ["/misc/ default.nix"] [])
    (mod ["/experimental/"] ["__"])
    (mod ["/themes/"] ["catppuccin" "rnoise"])
    #(mod ["/services/ waybar"] ["waybar_ref" "notifi"])
    (mod ["/services/ .nix"] ["waybar_ref" "notifi" "clipboard" "media" "macOS"])
    #(mod ["/services/ hyprpanel"] ["ref" "presets" "scripts"])

    [
      #./services
      ./programs
      ./packages
    ]
  ];
}
