{ tiny-cmdline-nvim, ... }:
final: prev: {
  vimPlugins = prev.vimPlugins // {
    tiny-cmdline-nvim = prev.vimUtils.buildVimPlugin {
      pname = "tiny-cmdline.nvim";
      version = tiny-cmdline-nvim.shortRev or "dirty";
      src = tiny-cmdline-nvim;
      meta.homepage = "https://github.com/rachartier/tiny-cmdline.nvim";
    };
  };
}
