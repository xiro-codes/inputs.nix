{ lib }:
let
  inherit (builtins)
    pathExists
    readDir
    filter
    attrNames
    all
    ;
  metaLib = import ./meta.nix { };

  # Get all directories in a path
  getDirs =
    path:
    if pathExists path then
      let
        contents = readDir path;
      in
      filter (name: contents.${name} == "directory") (attrNames contents)
    else
      [ ];

  # Get directories that contain all specified files and aren't broken
  getDirsWith = path: requiredFiles:
    filter (name:
      let 
        dir = path + "/${name}";
        hasFiles = all (f: pathExists (dir + "/${f}")) requiredFiles;
      in
      hasFiles && !(metaLib.isBroken (dir + "/meta.nix"))
    ) (getDirs path);
in
{
  inherit getDirs getDirsWith;

  # Get directories that contain a default.nix file
  getValidSubdirs = path: getDirsWith path [ "default.nix" ];
}
