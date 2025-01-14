{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      csharp-ls
    ];
    extraPlugins = with pkgs.vimPlugins; [
      csharpls-extended-lsp-nvim
    ];

    plugins.lsp.servers.csharp_ls = {
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
    };
  };
}
