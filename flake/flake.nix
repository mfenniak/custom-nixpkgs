{
  description = "mfenniak's custom-nixpkgs flake";

  outputs = { self }: {
    overlays.default = self: super: {
      csv-to-clipboard = self.callPackage ../csv-to-clipboard.nix {};
      prometheus-podman-exporter = self.callPackage ../prometheus-podman-exporter.nix {};
    };

    nixosModules.prometheus-exporter-podman = { ... }: {
      imports = [ ../prometheus/exporters.nix ];
    };

    nixosModules.detect-reboot-needed = { ... }: {
      imports = [ ../detect-reboot-needed.nix ];
    };
  };
}
