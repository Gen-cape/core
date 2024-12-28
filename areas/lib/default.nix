{inputs, ...} @ pargs: let
  inherit (inputs.nixpkgs) lib;

  inherit
    (import ./callers.nix {
      mimics = customLib;
      inherit lib;
    })
    callWith
    fzf
    wrench
    ;

  callSelf = caller: self:
    caller (lib.recursiveUpdate pargs {
      inherit lib;
      mimics = self;
    });

  # The components of lib that are needed to build the lib as a whole
  # Define manual volumes and so here
  baseLib = lib.makeExtensible (self: let
    call = callSelf callWith customLib;
    systemLibs = ["builders" "modules" "services" "themes"];
    langLibs = ["options" "path" "tools"];
    callLibs = prefix: cont: lib.foldl' (exp: acc: lib.recursiveUpdate exp acc) {} (map (m: {"${m}" = call (./${prefix} + "/${m}.nix");}) cont);
  in
    {
      e = call ./experimental/debug.nix;
      xdgTemplate = ./system/xdgTemplate.nix; # yeah, intentionally not called
      inherit (self.tools) callWith;
      inherit (self.path) getModulesFzf;
    }
    // callLibs "lang" langLibs
    // callLibs "system" systemLibs);

  # Autoparsed bulk of the modules
  coreLib = lib.makeExtensible (self: let
    call = callSelf baseLib.callWith customLib;
  in
    wrench [
      (map call)
      (lib.foldl' (exp: acc: lib.recursiveUpdate exp acc) {})
    ] (fzf ./. "!default.nix !old !debug !__"));

  # Merged result into a single lib
  customLib = baseLib.extend (lib.composeManyExtensions [
    (_: _: coreLib)
  ]);
in {
  perSystem = {
    _module.args.qol = customLib;
  };

  flake = {
    qol = customLib;
    debugRes = let
    in "";
  };
}
