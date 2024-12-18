{ pkgs }:
let
  downloadPlugin =
    {
      name,
      version,
      url,
      hash,
    }:
    pkgs.stdenv.mkDerivation {
      inherit name version;
      src = pkgs.fetchzip {
        inherit url hash;
      };
      installPhase = ''
        mkdir -p $out
        cp -r . $out
      '';
    };

in
[
  (downloadPlugin {
    name = "catppuccin";
    version = "3.4.0";
    url = "https://downloads.marketplace.jetbrains.com/files/18682/633467/Catppuccin_Theme-3.4.0.zip";
    hash = "sha256-a26wxw2/pJHt3SwNl0lzD/koKP77EhWpfNe3vw2rBco=";
  })
  (downloadPlugin {
    name = "github-copilot";
    version = "1.5.29.7524";
    url = "https://downloads.marketplace.jetbrains.com/files/17718/631741/github-copilot-intellij-1.5.29.7524.zip";
    hash = "sha256-ljVGVi/i36EnLxzK7IVGiKVF8EyQTeNVCVKBtGlYNmg=";
  })
  "ideavim"
]
