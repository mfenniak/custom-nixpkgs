{
  description = "mfenniak's custom-nixpkgs flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    overlays.default = self: super: {
      csv-to-clipboard = self.callPackage ../csv-to-clipboard.nix {};
    };
  };
}
