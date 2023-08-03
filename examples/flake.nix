{
  description = "Pandoc environment with BBCode writer";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pandoc-bbcode_nexus.url = "github:loicreynier/pandoc-bbcode_nexus";
  };
  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  } @ inputs: (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {inherit system;};
    pandocUserData = pkgs.buildEnv {
      name = "pandoc-user-data";
      paths = [
        inputs.pandoc-bbcode_nexus.packages.${system}.default
      ];
    };
    pandocWrapped = pkgs.writeShellScriptBin "pandoc" ''
      exec env XDG_DATA_HOME=${pandocUserData}/share \
        ${pkgs.pandoc}/bin/pandoc "$@"
    '';
  in rec {
    devShells.default = pkgs.mkShell {
      propagatedBuildInputs = [pandocWrapped];
    };
  }));
}
