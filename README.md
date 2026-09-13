# ios-simulator-mcp-flake

```nix
{
  inputs.ios-simulator-mcp-flake.url = "github:kimhappy/ios-simulator-mcp-flake";

  outputs = { nixpkgs, ios-simulator-mcp-flake, ... }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        overlays = [ ios-simulator-mcp-flake.overlays.default ];
      };
    in
    {
      # pkgs.ios-simulator-mcp, pkgs.fb-idb
    };
}
```
