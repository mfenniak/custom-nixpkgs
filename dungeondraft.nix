{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, gtk2
, openssl
, pcsclite
, requireFile
, libXcursor
, libXinerama
, libXext
, libXrandr
, libXi
, libGL
, zlib
, libkrb5
, udev
, makeWrapper
, zenity
}:

stdenv.mkDerivation rec {
  pname = "dungeondraft";
  version = "1.1.0.5";

  # nix-store --add-fixed sha256 Dungeondraft-1.1.0.5-Linux64.deb
  src = requireFile {
    name = "Dungeondraft-${version}-Linux64.deb";
    sha256 = "12x6a3rrghkznjyl86parq9hiw2vh4k5czk20032bdv7glkxwlan";
    url = "https://dungeondraft.net/";
  };

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  buildInputs = [
    libXcursor
    libXinerama
    libXext
    libXrandr
    libXi
    libGL
    zlib
    libkrb5
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/opt/Dungeondraft
    mv opt/Dungeondraft/* $out/opt/Dungeondraft

    # Can't use wrapProgram because godot seems to load data files based upon executable name
    makeWrapper $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/opt/Dungeondraft/Dungeondraft.x86_64.wrapped \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]} \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}

    mkdir -p $out/share/applications
    mv usr/share/applications/* $out/share/applications

    sed -i "s|Exec=/opt/Dungeondraft/Dungeondraft.x86_64|Exec=$out/opt/Dungeondraft/Dungeondraft.x86_64.wrapped|g" $out/share/applications/Dungeondraft.desktop
    sed -i "s|Path=/opt/Dungeondraft|Path=$out/opt/Dungeondraft|g" $out/share/applications/Dungeondraft.desktop
    sed -i "s|Icon=/opt/Dungeondraft/Dungeondraft.png|Icon=$out/opt/Dungeondraft/Dungeondraft.png|g" $out/share/applications/Dungeondraft.desktop
  '';
}
