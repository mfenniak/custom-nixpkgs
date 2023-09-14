{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "lib-rpi-rgb-led-matrix";
  version = "a3eea997a9254b83ab2de97ae80d83588f696387";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "rpi-rgb-led-matrix";
    rev = version;
    sha256 = "sha256-IUP9mDdUrV8mkmA21VsjLKhbPtJZ4Ln2kcxPRgplbgs=";
  };

  patches = [
    # /proc/cpuinfo doesn't include "Revision" on NixOS on a RPI; I've patched DetermineRaspberryModel in this package
    # to force it to assume the system is a PI_MODEL_4 as a hack to get around this.
    # DISABLED: using https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/cpu-revision.nix adds the revision to /proc/cpuinfo; better approach
    # ./rpi-rgb-led-matrix-PI4.patch
  ];

  buildPhase = ''
    runHook preBuild
    make all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mkdir -p $out/include
    mkdir -p $out/bin
    mkdir -p $out/fonts
    find
    cp lib/librgbmatrix.so.1 $out/lib/
    cp lib/librgbmatrix.a $out/lib/
    cp include/*.h $out/include/
    cp examples-api-use/demo $out/bin/
    cp examples-api-use/minimal-example $out/bin/
    cp examples-api-use/c-example $out/bin/
    cp examples-api-use/text-example $out/bin/
    cp examples-api-use/scrolling-text-example $out/bin/
    cp examples-api-use/clock $out/bin/
    cp examples-api-use/ledcat $out/bin/
    cp examples-api-use/input-example $out/bin/
    cp examples-api-use/pixel-mover $out/bin/
    cp fonts/* $out/fonts/

    runHook postInstall
  '';
}
