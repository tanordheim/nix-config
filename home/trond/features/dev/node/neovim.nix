{ pkgs, config, ... }:
let
  vscFile = "\${file}";
  vscWorkspaceFolder = "\${workspaceFolder}";
in
{
  imports = [ ../../editors/neovim ];

  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        javascript
        typescript
      ];

      plugins.lsp.servers.vtsls = {
        enable = true;
      };

      plugins.lsp.servers.eslint = {
        enable = true;
        settings = {
          workingDirectory.mode = "auto";
        };
      };

      plugins.conform-nvim.settings = {
        formatters_by_ft.javascript = [ "prettierd" ];
        formatters_by_ft.typescript = [ "prettierd" ];
        formatters_by_ft.javascriptreact = [ "prettierd" ];
        formatters_by_ft.typescriptreact = [ "prettierd" ];
        formatters.prettierd = {
          command = "${pkgs.prettierd}/bin/prettierd";
        };
      };

      extraPackages = with pkgs; [
        prettierd
        vscode-js-debug
        vscode-langservers-extracted
        vtsls
      ];

      extraPlugins = with pkgs.vimPlugins; [
        nvim-dap-vscode-js
      ];

      extraConfigLua = # lua
        ''
          require('dap-vscode-js').setup({
            debugger_path = '${pkgs.vscode-js-debug}/lib/node_modules/@vscode/js-debug',
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
          })

          for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
            require('dap').configurations[language] = {
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${vscFile}',
                cwd = '${vscWorkspaceFolder}',
              },
              {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${vscWorkspaceFolder}',
              },
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Debug Jest tests',
                runtimeExecutable = 'node',
                runtimeArgs = { './node_modules/jest/bin/jest.js', '--runInBand' },
                rootPath = '${vscWorkspaceFolder}',
                cwd = '${vscWorkspaceFolder}',
                console = 'integratedTerminal',
                internalConsoleOptions = 'neverOpen',
              },
            }
          end
        '';
    };
}
