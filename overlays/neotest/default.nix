{ ... }:
final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    vfinal: vprev: {
      neotest = vprev.neotest.overrideAttrs (_: {
        doCheck = false;
      });
    }
  );
}
