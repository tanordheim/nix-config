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
        vim.lsp.config('copilot_ls', {
          cmd = { '${pkgs.copilot-language-server}/bin/copilot-language-server', '--stdio' },
          init_options = {
            editorInfo = {
              name = 'neovim',
              version = tostring(vim.version()),
            },
            editorPluginInfo = {
              name = 'copilot-lsp',
              version = '1.0',
            },
          },
          settings = {
            telemetry = { telemetryLevel = 'off' },
          },
          root_markers = { '.git' },
        })
        vim.lsp.enable('copilot_ls')
      '';
  };
}
