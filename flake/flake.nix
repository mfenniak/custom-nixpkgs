{
  description = "mfenniak's custom-nixpkgs flake";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      packages = rec {
        alertmanager-mqtt-bridge = pkgs.callPackage ../alertmanager-mqtt-bridge.nix {};
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
        multicorn2 = postgresql: python: (pkgs.callPackage ../multicorn2.nix {
          inherit postgresql;
          python3 = python;
        }).package;
        multicorn2Python = postgresql: python: (pkgs.callPackage ../multicorn2.nix {
          inherit postgresql;
          python3 = python;
        }).pythonPackage;
        dotnet-symbol = pkgs.callPackage ../dotnet-symbol.nix {};
      };
    })) // {
      overlays.default = self: super: {
        alertmanager-mqtt-bridge = self.callPackage ../alertmanager-mqtt-bridge.nix {};
        prometheus-podman-exporter = self.callPackage ../prometheus-podman-exporter.nix {};
        plasma-applet-display-profile-switcher = self.callPackage ../plasma-applet-display-profile-switcher.nix {};
        dungeondraft = self.callPackage ../dungeondraft.nix {};
        wonderdraft = self.callPackage ../wonderdraft.nix {};
        dotnet-symbol = self.callPackage ../dotnet-symbol.nix {};
      };

      nixosModules.prometheus-exporter-podman = { ... }: {
        imports = [ ../prometheus/exporters.nix ];
      };

      nixosModules.detect-reboot-needed = { ... }: {
        imports = [ ../detect-reboot-needed.nix ];
      };
    };
}
