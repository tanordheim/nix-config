{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      stylua
    ];

    plugins.conform-nvim = {
      enable = true;

      settings = {
        format_on_save = # lua
          ''
            function(bufnr)
              local disable_filetypes = { c = true, cpp = true }
              local lsp_format_opt
              if disable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = 'never'
              else
                lsp_format_opt = 'fallback'
              end
              return {
                timeout_ms = 500,
                lsp_format = lsp_format_opt,
              }
            end
          '';
        formatters_by_ft = {
          cs = [ "csharpier" ];
          go = [ "goimports" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          terraform = [ "terraform_fmt" ];
        };
        formatters = {
          csharpier = {
            command = "dotnet";
            args = [
              "tool"
              "run"
              "--allow-roll-forward"
              "dotnet-csharpier"
              "--write-stdout"
            ];
          };
          goimports = {
            command = "${pkgs.gotools}/bin/goimports";
          };
          nixfmt = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          };
          stylua = {
            command = "${pkgs.stylua}/bin/stylua";
          };
          terraform_fmt = {
            command = "${pkgs.terraform}/bin/terraform";
          };
        };
      };
    };

    keymaps = [
      {
        key = "<leader>f";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('conform').format { async = true, lsp_format = 'fallback' }
            end
          '';
        options.desc = "[F]ormat buffer";
      }
    ];
  };
}
