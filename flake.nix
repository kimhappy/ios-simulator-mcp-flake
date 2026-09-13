{
  inputs.ios-simulator-mcp = {
    url = "github:joshuayoes/ios-simulator-mcp/v2.1.0";
    flake = false;
  };

  outputs =
    { ios-simulator-mcp, ... }:
    {
      overlays.default =
        final: _prev:
        let
          src = ios-simulator-mcp;
        in
        {
          ios-simulator-mcp = final.buildNpmPackage {
            pname = "ios-simulator-mcp";
            inherit (builtins.fromJSON (builtins.readFile "${src}/package.json")) version;
            inherit src;
            npmDeps = final.importNpmLock { npmRoot = src; };
            inherit (final.importNpmLock) npmConfigHook;
            npmFlags = [ "--legacy-peer-deps" ];

            meta = {
              description = "MCP server for interacting with the iOS simulator";
              homepage = "https://github.com/joshuayoes/ios-simulator-mcp";
              license = final.lib.licenses.mit;
              platforms = final.lib.platforms.darwin;
              mainProgram = "ios-simulator-mcp";
            };
          };

          fb-idb = final.python3Packages.buildPythonApplication rec {
            pname = "fb-idb";
            version = "1.5.7";
            format = "wheel";

            src = final.python3Packages.fetchPypi {
              inherit version format;
              pname = "fb_idb";
              dist = "py3";
              python = "py3";
              hash = "sha256-yguVi3FOVMuBPlegFr4cfceqCWy5LwGbMbzJMKJVVIU=";
            };

            nativeBuildInputs = [ final.makeWrapper ];

            dependencies = with final.python3Packages; [
              aiofiles
              grpclib
              protobuf
            ];

            pythonImportsCheck = [ "idb" ];

            postInstall = ''
              wrapProgram $out/bin/idb --prefix PATH : ${final.idb-companion}/bin
            '';

            meta = {
              description = "iOS debug bridge";
              homepage = "https://github.com/facebook/idb";
              license = final.lib.licenses.mit;
              platforms = final.lib.platforms.darwin;
              mainProgram = "idb";
            };
          };
        };
    };
}
