{ pkgs, config, ... }:
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      capabilities = # lua
        ''
          capabilities = require('blink.cmp').get_lsp_capabilities()
        '';
      onAttach = # lua
        ''
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<leader>uh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = 'Toggle inlay hints' })

            -- enable inlay hints by default
            vim.lsp.inlay_hint.enable()
          end
        '';
    };

    keymaps = [
      {
        key = "gd";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_definitions()
            end
          '';
        options.desc = "[G]oto [D]efinition";
      }
      {
        key = "grr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_references()
            end
          '';
        options.desc = "Goto references";
      }
      {
        key = "gri";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_implementations()
            end
          '';
        options.desc = "Goto implementation";
      }
      {
        key = "grt";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_type_definitions()
            end
          '';
        options.desc = "Goto type definition";
      }
      {
        key = "gO";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_symbols()
            end
          '';
        options.desc = "Document symbols";
      }
      {
        key = "<leader>ss";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_symbols()
            end
          '';
        options.desc = "[S]ymbols in document";
      }
      {
        key = "<leader>sS";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_workspace_symbols()
            end
          '';
        options.desc = "[S]ymbols in workspace";
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
      {
        key = "[d";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.diagnostic.jump({ count = -1, float = true })
            end
          '';
        options.desc = "Goto previous diagnostic";
      }
      {
        key = "]d";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.diagnostic.jump({ count = 1, float = true })
            end
          '';
        options.desc = "Goto next diagnostic";
      }
    ];
  };
}
