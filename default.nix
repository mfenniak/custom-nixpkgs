{ system ? builtins.currentSystem, ... }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    alertmanager-mqtt-bridge = callPackage ./alertmanager-mqtt-bridge.nix {};
    csv-to-clipboard = callPackage ./csv-to-clipboard.nix {};
    prometheus-podman-exporter = callPackage ./prometheus-podman-exporter.nix {};
    zinc = callPackage ./zinc/default.nix {};
    plasma-applet-display-profile-switcher = callPackage ./plasma-applet-display-profile-switcher.nix {};
    dungeondraft = callPackage ./dungeondraft.nix {};
    lib-rpi-rgb-led-matrix = callPackage ./lib-rpi-rgb-led-matrix.nix {};
    python-librgbmatrix = callPackage ./python-librgbmatrix.nix {};
    dotnet-symbol = callPackage ./dotnet-symbol.nix {};
  };
in
self
