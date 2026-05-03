{ fs }:
let
  inherit (builtins) listToAttrs map;
  metaLib = import ./meta.nix { };
in
{
  # Build module attribute set from discovered directories
  mkModules =
    path:
    let
      names = fs.getValidSubdirs path;
    in
    listToAttrs (
      map (name: {
        inherit name;
        value = path + "/${name}";
      }) names
    );
}
