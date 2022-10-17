{ system ? builtins.currentSystem, ... }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    csv-to-clipboard = callPackage ./csv-to-clipboard.nix {};
  };
in
self
