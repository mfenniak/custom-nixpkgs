{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/998f0f7924198b2460458728de59fe738997f28e.tar.gz";
    sha256 = "sha256:1iph9yydfk7a7r2b8137v96d9v6jrnbspbvra30kkcrjm1c1gin0";
  }) {}
}:

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
}
