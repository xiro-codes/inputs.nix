let
  lib = import <nixpkgs/lib>;
  fs = import ./discovery/fs.nix { inherit lib; };
  path = ./modules/system; # a path with some subdirectories
  runCount = 10000;
  res = builtins.genList (x: fs.getDirsWith path ["default.nix"]) runCount;
in
  builtins.deepSeq res "done"
