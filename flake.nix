{
  inputs = {
    nixpkgs.url = "nixpkgs/007ccf2f4f1da567903ae392cbf19966eb30cf20";
    swiftPm = {
      url = "github:dduan/nixSwiftPM";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.swift.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, swiftPm }:
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

