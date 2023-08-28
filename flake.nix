{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk-package = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, naersk-package, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [(import rust-overlay)];
      pkgs = import nixpkgs {inherit system overlays;};
      naersk = pkgs.callPackage naersk-package {};
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.rust-bin.nightly.latest.default
        ];
      }; 

      defaultPackage = naersk.buildPackage {
        src = ./.;
      };
    });
}