{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        proto
      ];

      plugins.lsp.servers.protols = {
        enable = true;
        cmd = [ "${pkgs.protols}/bin/protols" ];
      };

      plugins.conform-nvim.settings = {
        formatters_by_ft.proto = [ "buf" ];
        formatters.buf = {
          command = "${pkgs.buf}/bin/buf";
        };
      };

      extraPackages = with pkgs; [
        buf
        protols
      ];
    };
}
