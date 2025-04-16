{ lib, stdenv }:
stdenv.mkDerivation {
  pname = "pandoc-bbcode_nexus-writer";
  version = "unstable-2024-03-18";

  src = ../.;

  dontBuild = true;

  installPhase = ''
    install -Dt $out/share/pandoc/writers bbcode_nexus.lua
  '';

  meta = with lib; {
    homepage = "https://github.com/loicreynier/pandoc-bbcode_nexus";
    description = "Pandoc Lua writer for Nexus Mods BBCode";
    license = licenses.unlicense;
    maintainers = with maintainers; [ loicreynier ];
  };
}
