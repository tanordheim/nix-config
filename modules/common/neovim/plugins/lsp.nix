{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.lsp = {
      enable = true;
      inlayHints = true;
      capabilities = # lua
        ''
          capabilities = require('blink.cmp').get_lsp_capabilities()
        '';
    };

    extraConfigLua = # lua
      ''
         local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
         local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

         vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
           border = 'rounded',
           max_width = max_width,
           max_height = max_height,
         })

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = 'rounded',
          max_width = max_width,
          max_height = max_height,
        })
      '';

    keymaps = [
      {
        key = "<leader>gd";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').lsp_definitions()
            end
          '';
        options.desc = "[G]oto [D]efinition";
      }
      {
        key = "<leader>gi";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').lsp_implementations()
            end
          '';
        options.desc = "[G]oto [I]mplementation";
      }
      {
        key = "<leader>gr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').lsp_references()
            end
          '';
        options.desc = "[G]oto [R]eferences";
      }
      {
        key = "<leader>sd";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').lsp_document_symbols()
            end
          '';
        options.desc = "[S]ymbols in [D]ocument";
      }
      {
        key = "<leader>sw";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').lsp_dynamic_workspace_symbols()
            end
          '';
        options.desc = "[S]ymbols in [W]orkspace";
      }
      {
        key = "<C-k>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.lsp.buf.signature_help()
            end
          '';
        options.desc = "Signature help";
      }
      {
        key = "<leader>rn";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.lsp.buf.rename()
            end
          '';
        options.desc = "[R]e[n]ame";
      }
      {
        key = "<leader>ca";
        mode = [
          "n"
          "v"
        ];
        action.__raw = # lua
          ''
            function()
              vim.lsp.buf.code_action()
            end
          '';
        options.desc = "[C]ode [A]ction";
      }
    ];
  };

  imports = [
    ./lsp/csharp.nix
    ./lsp/go.nix
    ./lsp/html.nix
    ./lsp/yaml.nix
  ];
}
