{
  stdenv,
  fetchFromGitHub,
  curl,
  git,
  python3Packages,
}:

let
  yugabyteSource = 
    /home/mfenniak/Dev/yugabyte-db;
    # fetchFromGitHub {
    #   owner = "yugabyte";
    #   repo = "yugabyte-db";
    #   rev = "v2.17.0.0";
    #   sha256 = "sha256-hrbVof47QoK4WW4xz2IXKU7slo+wRnlMCzfVNrFZReI=";
    # };
  yugabyteBashCommonSha1 = "06fdecffba1970934a139b3f2dfdf684789c212c";
  yugabyteBashCommon = stdenv.mkDerivation {
    name = "yugabyte-bash-common";
    src = fetchFromGitHub {
      owner = "yugabyte";
      repo = "yugabyte-bash-common";
      rev = yugabyteBashCommonSha1;
      sha256 = "sha256-rOIxvM6b68YabyIbDIWqhbUVvqXL+8CQlObkMX4mMDY=";
    };
    installPhase = ''
      runHook preInstall
      mkdir -p $out/src
      cp src/* $out/src
      runHook postInstall
    '';
  };
  yugabytePython = stdenv.mkDerivation {
    name = "yugabyte-python";
    src = yugabyteSource;
    nativeBuildInputs = [ python3Packages.pip ];
    installPhase = ''
      runHook preInstall
      pip install -r requirements.txt
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  name = "yugabyte-db";
  src = yugabyteSource;

  patches = [
    ./0001-yugabyte-bash.patch
    # ./0002-tmp.patch
  ];

  nativeBuildInputs = [
    git
    curl
    yugabytePython
  ];

  buildPhase = ''
    runHook preBuild

    yugabyteBashCommonSha1=$(cat build-support/yugabyte-bash-common-sha1.txt)
    if [[ $yugabyteBashCommonSha1 != ${yugabyteBashCommonSha1} ]];
    then
      echo "build-support/yugabyte-bash-common-sha1.txt does not match package's expected ${yugabyteBashCommonSha1}"
      echo "Update the package to match."
      exit 1
    fi

    export YB_BASH_COMMON_DIR=${yugabyteBashCommon}
    patchShebangs ./yb_build.sh
    ./yb_build.sh --no-download-thirdparty --verbose release

    runHook postBuild
  '';

}
