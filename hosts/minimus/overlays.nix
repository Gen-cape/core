{
  lib,
  inputs,
  ...
}: {
  nixpkgs.overlays =
    lib.mkDefault []
    ++ [
      (self: super: {
        # Attempt to address util-linux duplication for fuse3
        # This was noted as potentially problematic in the article (infinite recursion for fuse2).
        # If build issues arise, this overlay might be the cause.
        # fuse3 = (self.lib.dontRecurseIntoAttrs (self.callPackage (inputs.nixpkgs + "/pkgs/os-specific/linux/fuse") {})).fuse_3;
        # Tinker later
      })
    ];
}
