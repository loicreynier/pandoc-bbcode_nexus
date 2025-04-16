{
  description = "Pandoc Nexus Mods BBCode writer";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      git-hooks,
    }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    {
      templates.default = {
        path = ./template;
        description = "Nix shell with Pandoc BBCode Nexus writer wrapper";
      };
    }
    // flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        writer = pkgs.callPackage ./nix/default.nix { };
        runner = pkgs.callPackage ./nix/runner.nix { inherit writer; };
      in
      {
        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;

            hooks = {
              commitizen.enable = true;
              deadnix.enable = true;
              editorconfig-checker.enable = true;
              nixfmt-rfc-style.enable = true;
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

        devShells.default =
          let
            inherit (self.packages.${system}) pandoc-bbcode_nexus; # pandoc-bbcode_nexus-writer;
          in
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
          pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              pandoc
              pandoc-bbcode_nexus
              # pandocWrapped
            ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
      }
    );
}
