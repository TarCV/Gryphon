{
  inputs = {
    nixpkgs.url = "nixpkgs/release-21.11";
    swift.url = "github:dduan/swift-builders";
    swiftPm.url = "github:dduan/nixSwiftPM";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, swift, swiftPm }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in rec {
        gryphon = (swiftPm.lib { pkgs = pkgs; }).buildExecutableProduct {
           src = ./.;
           productName = "Gryphon";
           executableName = "gryphon";
        };

        defaultPackage = gryphon;
      }
    )
  );
}

