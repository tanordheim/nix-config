{ ... }:
final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      # WORKAROUND: afdko 5.0.1 fails its addfeatures/makeotf test suite on
      # darwin (unsigned-integer underflow in addfeatures/hmtx). Fixed upstream
      # in https://github.com/NixOS/nixpkgs/pull/535882 (issue #535868) but that
      # merged 2026-06-28, after nixpkgs pin e73de5b (2026-06-26). Blocks
      # noto-fonts-color-emoji -> nototools -> afdko. Remove once nixpkgs is
      # bumped past the merge.
      afdko = pyprev.afdko.overridePythonAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
