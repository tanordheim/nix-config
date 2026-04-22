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

        vim.api.nvim_create_user_command("LspCopilotSignIn", function()
          local clients = vim.lsp.get_clients({ name = "copilot_ls" })
          if #clients == 0 then
            vim.notify("copilot_ls not attached", vim.log.levels.ERROR)
            return
          end
          clients[1]:request("signIn", vim.empty_dict(), nil, 0)
        end, { desc = "Copilot: sign in via LSP device flow" })
      '';
  };
}
