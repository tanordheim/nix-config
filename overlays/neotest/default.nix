{ ... }:
final: prev: {
  vimPlugins = prev.vimPlugins // {
    # WORKAROUND: neotest's busted runner exits nonzero despite all tests
    # passing, a regression from neovim 0.12.3 (nixpkgs e73de5b). No upstream
    # issue filed yet; symptom is checkPhase failing with 0 failures/0 errors.
    neotest = prev.vimPlugins.neotest.overrideAttrs (_: {
      doCheck = false;
    });
  };
}
