{
  description = "csv-to-clipboard nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.csv-to-clipboard =
      with import nixpkgs { system = "x86_64-linux"; };
      let
        desktopFile = pkgs.makeDesktopItem {
          name = "csv-to-clipboard";
          exec = "@out@/bin/csv-to-clipboard %f";
          desktopName = "csv-to-clipboard";
          mimeTypes = [ "text/csv" ];
        };
      in
      pkgs.rustPlatform.buildRustPackage rec {
        pname = "csv-to-clipboard";
        version = "1.1.0";

        src = pkgs.fetchFromGitHub {
          owner = "mfenniak";
          repo = pname;
          rev = version;
          sha256 = "sha256-Aag741LAD/C7ajJmIs7bsCMg2mPfkYVIAdJ71ZIlAog=";
        };

        cargoSha256 = "sha256-6TNgMnVjfx/LLNkOwUx6Gs4x/fTFa5fw+CrhWv2vNFE=";

        nativeBuildInputs = [
          pkgs.python310
        ];

        buildInputs = [
          pkgs.xorg.libxcb
        ];

        postInstall = ''
          mkdir -p $out/share/applications
          substituteAll ${desktopFile}/share/applications/csv-to-clipboard.desktop $out/share/applications/csv-to-clipboard.desktop
        '';
      };

    # overlays.default = final: prev: rec {
    #   csv-to-clipboard = final.callPackage ../csv-to-clipboard.nix; # self.packages.x86_64-linux.csv-to-clipboard;
    # };

  };
}
