{
  description = "My custom go60 layout";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    zmk = {
      url = "github:moergo-sc/zmk";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    zmk,
    ...
  }: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-linux"
      ] (system: f system);
  in {
    packages = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      firmware = import zmk {
        pkgs = import "${zmk}/nix/pinned-nixpkgs.nix" {inherit system;};
      };
    in rec {
      default = combined;

      combined = pkgs.callPackage ./config {
        inherit pkgs firmware;
      };
    });
  };
}
