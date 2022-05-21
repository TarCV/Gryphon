{
  inputs = {
    nixpkgs.url = "nixpkgs/release-21.11";
    swift.url = "github:dduan/swift-builders";
    swiftPm.url = "github:dduan/nixSwiftPM";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, gryphon-src, swift, swiftPm }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in rec {
        packages.gryphon = swiftPm.lib.buildExecutableProduct {
            version = "0.18.1";
            src = ./.;
#           productName = "Gryphon";
           target = "Gryphon";
        };

        defaultPackage = packages.gryphon;
      }
    )
  );
}

