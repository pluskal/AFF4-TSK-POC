{
  description = "Nix flake for aff4tsk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    aff4-cpp-lite = {
      url = "github:pluskal/aff4-cpp-lite";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, aff4-cpp-lite, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, ... }:
        let
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
          packages = {
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
          };
        };
    };
}
