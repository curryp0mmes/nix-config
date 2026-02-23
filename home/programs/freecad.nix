{ inputs, ... }:
{
nixpkgs.overlays = [
  (final: prev: {
    freecad-dev = prev.freecad.overrideAttrs (oldAttrs: {
      pname = "freecad-dev";
      version = "1.1-dev";

      src = inputs.freecad-src;

      # Bring back ONLY the PYTHONPATH patch from the nixpkgs tree
      patches = [
        "${prev.path}/pkgs/by-name/fr/freecad/0001-NIXOS-don-t-ignore-PYTHONPATH.patch"
      ];

      postPatch = "";

      qtWrapperArgs = oldAttrs.qtWrapperArgs ++ [
        "--prefix PATH : ${prev.lib.makeBinPath [ prev.gmsh ]}"
      ];
    });
  })
];
}
