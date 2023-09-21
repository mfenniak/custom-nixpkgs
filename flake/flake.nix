{
  description = "mfenniak's custom-nixpkgs flake";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      overlays.default = self: super: {
        csv-to-clipboard = self.callPackage ../csv-to-clipboard.nix {};
        prometheus-podman-exporter = self.callPackage ../prometheus-podman-exporter.nix {};
        plasma-applet-display-profile-switcher = self.callPackage ../plasma-applet-display-profile-switcher.nix {};
        dungeondraft = self.callPackage ../dungeondraft.nix {};
        wonderdraft = self.callPackage ../wonderdraft.nix {};
      };

      packages = rec {
        lib-rpi-rgb-led-matrix = pkgs.callPackage ../lib-rpi-rgb-led-matrix.nix {};
        python-bdfparser = python: (pkgs.callPackage ../python-bdfparser.nix {
          inherit python;
        });
        python-rgbmatrixemulator = python: (pkgs.callPackage ../python-rgbmatrixemulator.nix {
          inherit python python-bdfparser;
        });
        python-librgbmatrix = python: (pkgs.callPackage ../python-librgbmatrix.nix {
          inherit lib-rpi-rgb-led-matrix python;
        });
      };
    } // {
      nixosModules.prometheus-exporter-podman = { ... }: {
        imports = [ ../prometheus/exporters.nix ];
      };

      nixosModules.detect-reboot-needed = { ... }: {
        imports = [ ../detect-reboot-needed.nix ];
      };
    });
}
