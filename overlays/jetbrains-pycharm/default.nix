{ ... }:
final: prev: {
  jetbrains = prev.jetbrains // {
    # WORKAROUND: cythonDebugSpeedupsHook lost its isLinux gate in
    # https://github.com/NixOS/nixpkgs/pull/553326 — on darwin sourceRoot is the
    # .app bundle, so setup_cython.py isn't under plugins/ and installPhase fails.
    pycharm = prev.jetbrains.pycharm.overrideAttrs (o: {
      nativeBuildInputs = builtins.filter (
        p: (p.pname or p.name or "") != "cython-debug-speedups-hook"
      ) o.nativeBuildInputs;
    });
  };
}
