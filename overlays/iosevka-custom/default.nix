{ ... }:
final: prev:
let
  iosevka-custom = prev.iosevka.override {
    set = "Custom";
    privateBuildPlan = {
      family = "Iosevka Custom";
      spacing = "term";
      serifs = "sans";
      noCvSs = true;
      exportGlyphNames = true;
      variants.inherits = "ss14";
      ligations.inherits = "dlig";
      widths.Normal = {
        shape = 550;
        menu = 5;
        css = "normal";
      };
    };
  };
in
{
  iosevka-custom-nerd = prev.stdenv.mkDerivation {
    pname = "iosevka-custom-nerd";
    version = iosevka-custom.version;
    src = iosevka-custom;
    nativeBuildInputs = [
      prev.parallel
      prev.nerd-font-patcher
    ];
    dontUnpack = true;
    buildPhase = ''
      runHook preBuild
      mkdir -p $out/share/fonts/truetype
      find $src -name '*.ttf' -print0 \
        | parallel -0 --will-cite \
            nerd-font-patcher --careful --complete --no-progressbars \
              --outputdir $out/share/fonts/truetype {}
      runHook postBuild
    '';
    dontInstall = true;
  };
}
