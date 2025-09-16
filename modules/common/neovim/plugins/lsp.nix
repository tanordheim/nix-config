{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.lsp = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "DeferredUIEnter";
        };
      };
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

    plugins.lspsaga = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "DeferredUIEnter";
        };
      };
      settings.lightbulb.enable = false;
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
        key = "gi";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_implementations()
            end
          '';
        options.desc = "[G]oto [I]mplementation";
      }
      {
        key = "gr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_references()
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
              Snacks.picker.lsp_symbols()
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
              Snacks.picker.lsp_workspace_symbols()
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
        action = "<cmd>Lspsaga rename<CR>";
        options.desc = "[R]e[n]ame";
      }
      {
        key = "<leader>rN";
        mode = "n";
        action = "<cmd>Lspsaga rename mode=n<CR>";
        options.desc = "[R]e[n]ame (normal mode)";
      }
      {
        key = "<leader>ca";
        mode = [
          "n"
          "v"
        ];
        action = "<cmd>Lspsaga code_action<CR>";
        options.desc = "[C]ode [A]ction";
      }
      {
        key = "[d";
        mode = [
          "n"
        ];
        action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
      }
      {
        key = "]d";
        mode = [
          "n"
        ];
        action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
        options.desc = "Goto next diagnostic";
      }
    ];
  };
}
