{ fetchFromGitHub, python, lib-rpi-rgb-led-matrix }:

python.pkgs.buildPythonPackage rec {
  pname = "python-librgbmatrix";
  version = "a3eea997a9254b83ab2de97ae80d83588f696387";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "rpi-rgb-led-matrix";
    rev = version;
    sha256 = "sha256-IUP9mDdUrV8mkmA21VsjLKhbPtJZ4Ln2kcxPRgplbgs=";
  };

  sourceRoot = "${src.name}/bindings/python";

  propagatedBuildInputs = [
    lib-rpi-rgb-led-matrix
    python.pkgs.pillow
  ];

  postPatch = ''
    echo "font_path = '${lib-rpi-rgb-led-matrix}/fonts'" >> rgbmatrix/__init__.py
  '';
}
