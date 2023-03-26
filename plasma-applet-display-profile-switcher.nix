{ stdenv, fetchFromGitHub, unzip, python3 }:

let
  my-python = (python3.withPackages(ps: [ ps.dbus-python ]));
in
stdenv.mkDerivation rec {
  pname = "plasma-applet-display-profile-switcher";
  version = "82df3fa";

  src = fetchFromGitHub {
    owner = "MakG10";
    repo = pname;
    rev = version;
    sha256 = "sha256-HTFhFOwCJ8A3nOcn4CeeByM3A3h9kiXrtB88/TWRHvA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids
    unzip display-profile-switcher.plasmoid -d $out/share/plasma/plasmoids
    mv $out/share/plasma/plasmoids/package $out/share/plasma/plasmoids/eu.makg.plasma.display-profile-switcher

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    sed -e "s#python3#${my-python}/bin/python3#g" -i $out/share/plasma/plasmoids/eu.makg.plasma.display-profile-switcher/contents/ui/main.qml
    sed -e "s#python3#${my-python}/bin/python3#g" -i $out/share/plasma/plasmoids/eu.makg.plasma.display-profile-switcher/contents/ui/config/configGeneral.qml

    sed -e "s#~/.local/share/plasma/plasmoids#$out/share/plasma/plasmoids#g" -i $out/share/plasma/plasmoids/eu.makg.plasma.display-profile-switcher/contents/ui/main.qml
    sed -e "s#~/.local/share/plasma/plasmoids#$out/share/plasma/plasmoids#g" -i $out/share/plasma/plasmoids/eu.makg.plasma.display-profile-switcher/contents/ui/config/configGeneral.qml

    runHook postFixup
  '';

  nativeBuildInputs = [
    unzip
  ];
  buildInputs = [
    my-python
  ];
}
