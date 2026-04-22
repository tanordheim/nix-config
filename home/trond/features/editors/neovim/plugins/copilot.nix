{ pkgs, config, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      copilot-lsp
    ];

    extraPackages = with pkgs; [
      copilot-language-server
    ];

    extraConfigLua = # lua
      ''
        require('copilot-lsp').setup({})
        vim.lsp.enable('copilot_ls')
      '';
  };
}
