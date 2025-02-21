{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages =
      # csharp-ls is broken on darwin, see https://github.com/razzmatazz/csharp-language-server/issues/211
      if pkgs.stdenv.isLinux then
        (with pkgs; [
          csharp-ls
        ])
      else
        [ ];
    extraPlugins = with pkgs.vimPlugins; [
      csharpls-extended-lsp-nvim
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c_sharp
    ];

    # csharp-ls is broken on darwin, see https://github.com/razzmatazz/csharp-language-server/issues/211
    plugins.lsp.servers.csharp_ls =
      if pkgs.stdenv.isLinux then
        {
          enable = true;
          cmd = [ "${pkgs.csharp-ls}/bin/csharp-ls" ];
          # TODO: reenable this
          # handlers = {
          #   "textDocument/definition" = # lua
          #     ''
          #       require('csharpls_extended').handler
          #     '';
          #   "textDocument/typeDefinition" = # lua
          #     ''
          #       require('csharpls_extended').handler
          #     '';
          # };
          # csharp_ls does not seem to provide an inlayHintProvider on the server capabilities, even though it supports inlay hints,
          # causing it to not be autoconfigured; enable inlay hints by force instead
          onAttach.function = # lua
            ''
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            '';
        }
      else
        { };

    plugins.conform-nvim = {
      settings.formatters_by_ft.cs = [ "csharpier" ];
      settings.formatters.csharpier = {
        command = "dotnet";
        args = [
          "tool"
          "run"
          "--allow-roll-forward"
          "dotnet-csharpier"
          "--write-stdout"
        ];
      };
    };

    plugins.neotest.adapters.dotnet = {
      enable = true;
      settings = {
        discovery_root = "solution";
      };
    };
  };
}
