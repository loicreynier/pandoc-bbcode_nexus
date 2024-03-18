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

The flake packages the `pandoc-bbcode_nexus` binary
which wraps

```bash
pandoc -t </nix/store/.../bbcode_nexus.lua> "@"
```

Since Pandoc does not have (yet) a standard location for custom writers,
this is probably the simplest solution for Nix distribution.
