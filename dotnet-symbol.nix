{
  lib,
  buildDotnetGlobalTool,
  # dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "dotnet-symbol";
  version = "9.0.553101";

  # dotnet-sdk = dotnetCorePackages.sdk_8_0;
  # dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetHash = "sha256-/pFODZt0azL+d1GyTz9BOyQ09ORAHU7LdFM7Rxg1ZFE=";

  meta = {
    description = "Symbol downloader dotnet cli extension";
    homepage = "https://github.com/dotnet/diagnostics";
    license = lib.licenses.mit;
    mainProgram = "dotnet-symbol";
    # maintainers = with lib.maintainers; [ tomasajt ];
  };
}
