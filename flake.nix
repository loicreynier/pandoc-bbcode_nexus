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
      writer = pkgs.callPackage ./nix/default.nix {};
      runner = pkgs.callPackage ./nix/runner.nix {inherit writer;};
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;

          hooks = {
            alejandra.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            editorconfig-checker.enable = true;
            prettier.enable = true;
            statix.enable = true;
            stylua.enable = true;
            typos.enable = true;
          };
        };
      };

      packages = {
        default = writer;
        pandoc-bbcode_nexus-writer = writer;
        pandoc-bbcode_nexus = runner;
      };

      devShells.default = let
        inherit (self.packages.${system}) pandoc-bbcode_nexus; # pandoc-bbcode_nexus-writer;
        # Writers are not collected by Pandoc in `XDG_DATA_HOME` (yet)
        # pandocUserData = pkgs.buildEnv {
        #   name = "pandoc-user-data";
        #   paths = [
        #     pandoc-bbcode_nexus-writer
        #   ];
        # };
        # pandocWrapped = pkgs.writeShellScriptBin "pandoc" ''
        #   exec env XDG_DATA_HOME=${pandocUserData}/share \
        #     ${pkgs.pandoc}/bin/pandoc "$@"
        # '';
      in
        pkgs.mkShell {
          nativeBuildInputs = [
            # pandocWrapped
            pandoc-bbcode_nexus
          ];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
    });
}
