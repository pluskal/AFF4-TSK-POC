{
  description = "Nix flake for aff4tsk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    aff4-cpp-lite = {
      url = "github:pluskal/aff4-cpp-lite";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, aff4-cpp-lite }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          aff4CppLite = pkgs.stdenv.mkDerivation {
            pname = "aff4-cpp-lite";
            version = "unstable";
            src = aff4-cpp-lite;
            nativeBuildInputs = [
              pkgs.cmake
              pkgs.pkg-config
            ];
            buildInputs = [
              pkgs.openssl
              pkgs.zlib
              pkgs.bzip2
              pkgs.lz4
              pkgs.libuuid
            ];
            cmakeFlags = [
              "-DBUILD_TESTING=OFF"
            ];
          };
        in
        {
          aff4-cpp-lite = aff4CppLite;

          default = pkgs.stdenv.mkDerivation {
            pname = "aff4tsk";
            version = "0.1.0";
            src = self;
            nativeBuildInputs = [
              pkgs.cmake
              pkgs.pkg-config
            ];
            buildInputs = [
              pkgs.sleuthkit
              aff4CppLite
            ];
          };
        });
    };
}
