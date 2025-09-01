{ pkgs, config, ... }:
let
  lensline-nvim-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "lensline.nvim";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "oribarilan";
      repo = "lensline.nvim";
      rev = "1.0.0";
      hash = "sha256-A1dE3PhDU2i7Jms38lUS6zL9xLcTCmvxT0jNzPQ2CvE=";
    };
  };
in
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPlugins = [
      lensline-nvim-plugin
    ];

    extraConfigLua = # lua
      ''
        require("lensline").setup {}
      '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>ul";
        action = "<cmd>LenslineToggle<CR>";
        options = {
          desc = "Lensline toggle";
        };
      }
    ];
  };
}
