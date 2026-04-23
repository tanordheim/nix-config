{ tiny-code-action-nvim, ... }:
final: prev: {
  vimPlugins = prev.vimPlugins // {
    tiny-code-action-nvim = prev.vimUtils.buildVimPlugin {
      pname = "tiny-code-action.nvim";
      version = tiny-code-action-nvim.shortRev or "dirty";
      src = tiny-code-action-nvim;
      nvimSkipModules = [
        "tiny-code-action.previewers.snacks"
        "tiny-code-action.previewers.telescope"
        "tiny-code-action.previewers.fzf-lua"
        "tiny-code-action.pickers.snacks"
        "tiny-code-action.pickers.telescope"
        "tiny-code-action.pickers.fzf-lua"
      ];
      meta.homepage = "https://github.com/rachartier/tiny-code-action.nvim";
    };
  };
}
