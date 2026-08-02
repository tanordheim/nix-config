{ ... }:
final: prev: {
  # WORKAROUND: nf-cod-openai (U+EC81) and nf-cod-claude (U+EC82) exist only in
  # nerd-fonts master (src/glyphs/codicons/codicon.ttf updated 2026-07-18,
  # i_cod.sh 2026-07-19) and ship in no release; v3.4.0 tops out at U+EC1E.
  # Remove this overlay once nerd-fonts 3.5.0 lands in nixpkgs.
  # https://github.com/ryanoasis/nerd-fonts/releases
  codicon-extras = prev.stdenvNoCC.mkDerivation {
    pname = "codicon-extras";
    version = "0-unstable-2026-07-18";

    src = prev.fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/515c4b92498a2a247d8c98fa8157fd2d8cb9a712/src/glyphs/codicons/codicon.ttf";
      hash = "sha256-ktOqKpFSRrEA3htTl7P6rkx8uVdq4FQ1G3HtqPIHVM8=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ (prev.python3.withPackages (ps: [ ps.fonttools ])) ];

    buildPhase = ''
      runHook preBuild
      python3 ${./mkfont.py} \
        $src \
        ${prev.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf \
        CodiconExtrasMono-Regular.ttf
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm444 CodiconExtrasMono-Regular.ttf \
        $out/share/fonts/truetype/CodiconExtrasMono-Regular.ttf
      runHook postInstall
    '';

    meta = {
      description = "Two-glyph fallback font supplying the unreleased Claude and OpenAI codicons at JetBrainsMono Nerd Font Mono metrics";
      homepage = "https://github.com/ryanoasis/nerd-fonts";
      license = prev.lib.licenses.cc-by-40;
      platforms = prev.lib.platforms.all;
    };
  };
}
