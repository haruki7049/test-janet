{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    buildJanetPackage.url = "github:haruki7049/buildJanetPackage";
  };

  outputs = { nixpkgs, flake-utils, buildJanetPackage, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        janetBuilder = import buildJanetPackage { inherit pkgs; };

        http-server = janetBuilder.buildJanetPackage {
          pname = "http-server";
          version = "0.1.0";
          src = lib.cleanSource ./.;
          depsFile = ./deps.nix;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.janet
            pkgs.jpm
          ];
        };

        packages = {
          inherit http-server;
          default = http-server;
        };
      });
}
