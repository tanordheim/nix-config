{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        modelArchive = pkgs.fetchurl {
          url = "https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/kokoro-multi-lang-v1_0.tar.bz2";
          hash = "sha256-wTPSY1PXdtpzCHDax9oH2/yaXjvIDMXo6Dq26CO+cEY=";
        };
        model = pkgs.runCommand "kokoro-multi-lang-v1_0" { nativeBuildInputs = [ pkgs.bzip2 ]; } ''
          mkdir "$out"
          tar --extract --bzip2 --file ${modelArchive} --strip-components=1 --directory "$out"
        '';
        kokoroTts = pkgs.writeShellScriptBin "kokoro-tts" ''
          exec ${pkgs.sherpa-onnx}/bin/sherpa-onnx-offline-tts \
            --kokoro-model=${model}/model.onnx \
            --kokoro-voices=${model}/voices.bin \
            --kokoro-tokens=${model}/tokens.txt \
            --kokoro-data-dir=${model}/espeak-ng-data \
            --kokoro-lexicon=${model}/lexicon-us-en.txt,${model}/lexicon-zh.txt \
            "$@"
        '';
      in
      {
        home.packages = [
          pkgs.sherpa-onnx
          kokoroTts
        ];

        xdg.dataFile."sherpa-onnx/models/kokoro-multi-lang-v1_0".source = model;
      }
    )
  ];
}
