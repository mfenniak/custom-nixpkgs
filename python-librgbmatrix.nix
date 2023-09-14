{ buildPythonPackage, fetchFromGitHub, python3, lib-rpi-rgb-led-matrix }:

buildPythonPackage rec {
  pname = "python-librgbmatrix";
  version = "a3eea997a9254b83ab2de97ae80d83588f696387";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = pname;
    rev = version;
    sha256 = "sha256-IUP9mDdUrV8mkmA21VsjLKhbPtJZ4Ln2kcxPRgplbgs=";
  };

  sourceRoot = "${src.name}/bindings/python";

  propagatedBuildInputs = [
    lib-rpi-rgb-led-matrix
    python3.pkgs.pillow
  ];
}
