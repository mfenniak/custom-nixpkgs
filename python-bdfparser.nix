{ fetchFromGitHub, python }:

python.pkgs.buildPythonPackage rec {
  pname = "python-bdfparser";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tomchen";
    repo = "bdfparser";
    rev = "v${version}";
    sha256 = "sha256-M7oWz74RAQd41ZZ1IGqgQFgG0+l1s8xPL+qUTRZnYGM=";
  };

  # sourceRoot = "${src.name}/bindings/python";

  propagatedBuildInputs = [
    # python.pkgs.bdfparser
    # lib-rpi-rgb-led-matrix
    python.pkgs.pillow
    python.pkgs.tkinter
  ];

  # postPatch = ''
  #   echo "font_path = '${lib-rpi-rgb-led-matrix}/fonts'" >> rgbmatrix/__init__.py
  # '';
}
