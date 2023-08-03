{
  description = "Pandoc Nexus Mods BBCode writer";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    pre-commit-hooks,
  }: let
    supportedSystems = ["x86_64-linux"];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in rec {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;

          hooks = with pkgs; {
            alejandra.enable = true;
            commitizen.enable = true;
            editorconfig-checker.enable = true;
            prettier.enable = true;
            statix.enable = true;
            stylua.enable = true;
            typos.enable = true;
          };
        };
      };

      packages.default = pkgs.callPackage ./default.nix {};

      devShells.default = let
        pandocUserData = pkgs.buildEnv {
          name = "pandoc-user-data";
          paths = [
            self.packages.${system}.default
          ];
        };
        pandocWrapped = pkgs.writeShellScriptBin "pandoc" ''
          exec env XDG_DATA_HOME=${pandocUserData}/share \
            ${pkgs.pandoc}/bin/pandoc "$@"
        '';
      in
        pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pandocWrapped
          ];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
    });
}
