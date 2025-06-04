{
  stdenv
  , fetchFromGitHub
  , postgresql
  , postgresqlTestHook
  , python3
  , clang
}:

let
  targetVersion = "v3.0";
  targetRevision = "aebb975d6081ea74310eed88503f8c8f26a6d41c"; # FIXME Note: pre-release version, not a tag, so not truly v3.0

  multicornSrc = fetchFromGitHub {
    owner = "mfenniak";
    repo = "multicorn2";
    rev = targetRevision;
    sha256 = "sha256-1RJIq+2B6+zRPILnKwTkkqPEEBS0dcU7ywP8uCqodpE=";
  };

  multicorn = stdenv.mkDerivation rec {
    pname = "multicorn2";
    version = targetVersion;
    src = multicornSrc;
    nativeBuildInputs = [
      postgresql.pg_config
      python3
      clang
    ];
    installPhase = ''
      runHook preInstall
      install -D multicorn${postgresql.dlSuffix} -t $out/lib/
      install -D sql/multicorn--''${version#v}.sql -t $out/share/postgresql/extension
      install -D multicorn.control -t $out/share/postgresql/extension
      runHook postInstall
    '';
  };

  multicornTest = stdenv.mkDerivation {
    name = "multicorn2-test";
    dontUnpack = true;
    doCheck = true;
    buildInputs = [ postgresqlTestHook ];
    nativeCheckInputs = [ (postgresql.withPackages (ps: [ multicorn ])) ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    failureHook = "postgresqlStop";
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -c "CREATE EXTENSION multicorn;"
      runHook postCheck
    '';
    installPhase = "touch $out";
  };

  multicornPython = python3.pkgs.buildPythonPackage rec {
    pname = "multicorn2-python";
    version = targetVersion;
    src = multicornSrc;
    nativeBuildInputs = [ postgresql.pg_config ];
  };

  multicornPythonTest = stdenv.mkDerivation {
    name = "multicorn2-python-test";
    dontUnpack = true;
    doCheck = true;
    buildInputs = [ postgresqlTestHook ];
    nativeCheckInputs = [
      (postgresql.withPackages (ps: [ multicorn ]))
      (python3.withPackages (ps: [ multicornPython ]))
    ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    failureHook = "postgresqlStop";
    checkPhase = ''
      runHook preCheck

      # extracted from multicorn_logger_test.sql
      psql -a -v ON_ERROR_STOP=1 -c "CREATE EXTENSION multicorn;"
      psql -a -v ON_ERROR_STOP=1 -c "CREATE server multicorn_srv foreign data wrapper multicorn options (
          wrapper 'multicorn.testfdw.TestForeignDataWrapper'
      );"
      psql -a -v ON_ERROR_STOP=1 -c "CREATE foreign table testmulticorn (
          test1 character varying,
          test2 character varying
      ) server multicorn_srv options (
          option1 'option1'
      );"
      psql -a -v ON_ERROR_STOP=1 -c "select * from testmulticorn;"
      psql -a -v ON_ERROR_STOP=1 -c "DROP EXTENSION multicorn cascade;"

      runHook postCheck
    '';
    installPhase = "touch $out";
  };

in {
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./multicorn2.nix {}' -A package -A pythonPackage
  package = multicorn;
  pythonPackage = multicornPython;

  # nix-build -E 'with import <nixpkgs> {}; callPackage ./multicorn2.nix {}' -A tests.extension -A tests.python
  tests = {
    extension = multicornTest;
    python = multicornPythonTest;
  };
}
