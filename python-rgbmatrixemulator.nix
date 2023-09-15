{ fetchFromGitHub, python, python-bdfparser }:

python.pkgs.buildPythonPackage rec {
  pname = "python-rgbmatrixemulator";
  version = "0.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ty-porter";
    repo = "RGBMatrixEmulator";
    rev = "v${version}";
    sha256 = "sha256-gS0BodwOpq/A+XYA5PsIzbW6NE4ZW68VeQVXo+WWqAY=";
  };

  buildInputs = [
    python.pkgs.pip
  ];

  propagatedBuildInputs = [
    python.pkgs.pygame
    python.pkgs.tornado
    python.pkgs.libsixel
    (python-bdfparser python)
  ];
}
