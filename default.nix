{
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "pandoc-bbcode_nexus-writer";
  version = "2022-09-01";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    install -Dt $out/share/pandoc/writers bbcode_nexus.lua
  '';

  meta = with lib; {
    homepage = "https://github.com/loicreynier/pandoc-bbcode_nexus";
    description = "Pandoc Lua writer for Nexus Mods BBCode";
    license = licenses.unlicense;
    maintainers = with maintainers; [loicreynier];
  };
}
