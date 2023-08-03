# Nexus Mods BBCode Pandoc writer

A WIP Pandoc Lua writer for [Nexus Mods][nexus] BBCode.

[nexus]: https://nexusmods.com

## Usage

```shell
pandoc -t <path-to>/bbcode_nexus.lua <input> -o <output>
```

## Features

- [x] Headers
- [x] Bold text
- [x] Italic text
- [x] Bullet List
- [x] Inline code (formatted as italic)
- [x] Code blocks
- [x] Quote blocks
- [ ] Image
- [ ] Video
- [ ] Spoiler

## Installation for Nix users

The flake provides a package that can you add to your Pandoc environment.
Here's a flake example:

```nix
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
```
