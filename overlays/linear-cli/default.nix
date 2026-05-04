{ ... }:
final: prev:
{
  linear-cli = prev.stdenvNoCC.mkDerivation rec {
    pname = "linear-cli";
    version = "2.0.0";

    src = prev.fetchurl {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-unknown-linux-gnu.tar.xz";
      sha256 = "affb594672c2f220cef68fa7cfeb813945c4010789a4b8cc2c0e46468feb7870";
    };

    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 linear $out/bin/linear
      runHook postInstall
    '';

    meta = {
      description = "CLI tool for linear.app that uses git branch names and directory names to open issues and team pages";
      homepage = "https://github.com/schpet/linear-cli";
      license = prev.lib.licenses.mit;
      mainProgram = "linear";
      platforms = [ "x86_64-linux" ];
    };
  };
}
