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
, gnome
, alsa-lib
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "wonderdraft";
  version = "1.1.7.3";

  # nix-store --add-fixed sha256 Dungeondraft-1.0.4.7-Linux64.deb
  src = requireFile {
    name = "Wonderdraft-${version}-Linux64.deb";
    sha256 = "157himdhpijcc7dk696p6d38kdsk8x44jzagraa8ax1mkhbikilb";
    url = "https://www.wonderdraft.net/";
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
    alsa-lib
    libpulseaudio
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  # .
  # ./env-vars
  # ./opt
  # ./opt/Wonderdraft
  # ./opt/Wonderdraft/EULA.txt
  # ./opt/Wonderdraft/Wonderdraft.pck
  # ./opt/Wonderdraft/Wonderdraft.png
  # ./opt/Wonderdraft/Wonderdraft.x86_64
  # ./usr
  # ./usr/share
  # ./usr/share/applications
  # ./usr/share/applications/Wonderdraft.desktop

  installPhase = ''
    mkdir -p $out/opt/Wonderdraft
    mv opt/Wonderdraft/* $out/opt/Wonderdraft

    # Can't use wrapProgram because godot seems to load data files based upon executable name
    makeWrapper $out/opt/Wonderdraft/Wonderdraft.x86_64 $out/opt/Wonderdraft/Wonderdraft.x86_64.wrapped \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]} \
      --prefix PATH : ${lib.makeBinPath [ gnome.zenity ]}

    mkdir -p $out/share/applications
    mv usr/share/applications/* $out/share/applications

    sed -i "s|Exec=/opt/Wonderdraft/Wonderdraft.x86_64|Exec=$out/opt/Wonderdraft/Wonderdraft.x86_64.wrapped|g" $out/share/applications/Wonderdraft.desktop
    sed -i "s|Path=/opt/Wonderdraft|Path=$out/opt/Wonderdraft|g" $out/share/applications/Wonderdraft.desktop
    sed -i "s|Icon=/opt/Wonderdraft/Wonderdraft.png|Icon=$out/opt/Wonderdraft/Wonderdraft.png|g" $out/share/applications/Wonderdraft.desktop
  '';
}
