{
  description = "Pandoc environment with BBCode writer";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pandoc-bbcode_nexus = {
      url = "github:loicreynier/pandoc-bbcode_nexus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    flake-utils,
    nixpkgs,
    ...
  } @ inputs: (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.default = pkgs.mkShell {
      propagatedBuildInputs = [
        inputs.pandoc-bbcode_nexus.packages.${system}.pandoc-bbcode_nexus
      ];
    };
  }));
}
