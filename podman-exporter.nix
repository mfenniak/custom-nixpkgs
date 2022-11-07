{ lib, stdenv, buildGoModule, fetchFromGitHub, nixosTests, btrfs-progs, pkg-config, gpgme, lvm2, conmon, makeWrapper }:

buildGoModule rec {
  pname = "prometheus-podman-exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3Itk7c6NbSPfbu9PV/2SwDmogTJEM01AqRuV44JsMjU=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ btrfs-progs gpgme lvm2.dev ];

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${lib.makeBinPath [ conmon ]}
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for podman environments";
    license = licenses.asl20;
    maintainers = with maintainers; [ mfenniak ];
    platforms = platforms.linux;
  };
}
