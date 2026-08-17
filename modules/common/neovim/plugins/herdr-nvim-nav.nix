{ inputs, pkgs, ... }:
let
  # WORKAROUND: herdr-nvim-nav is not available in nixpkgs or through nixvim.
  herdr-nvim-nav = pkgs.vimUtils.buildVimPlugin {
    pname = "herdr-nvim-nav";
    version = "1.0.0";
    src = inputs.herdr-nvim-nav;
  };
in
{
  programs.nixvim = {
    extraPlugins = [
      herdr-nvim-nav
      pkgs.vimPlugins.vim-tmux-navigator
    ];
    globals.tmux_navigator_no_mappings = 1;
    extraConfigLua = ''
      require("herdr-nvim-nav").setup({
        keymaps = {
          left = { "<C-h>" },
          down = { "<C-j>" },
          up = { "<C-k>" },
          right = { "<C-l>" },
        },
      })
    '';
  };
}
