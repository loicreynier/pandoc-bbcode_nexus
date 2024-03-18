{
  name ? "pandoc-bbcode_nexus",
  pandoc,
  writeShellScriptBin,
  writer,
}:
writeShellScriptBin name ''
  exec ${pandoc}/bin/pandoc \
    --to "${writer}/share/pandoc/writers/bbcode_nexus.lua" \
    "$@"
''
