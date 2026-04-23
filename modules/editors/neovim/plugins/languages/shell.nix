{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim =
          { config, ... }:
          {
            plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
              bash
            ];

            plugins.lsp.servers.bashls = {
              enable = true;
              cmd = [
                "${pkgs.bash-language-server}/bin/bash-language-server"
                "start"
              ];
            };

            plugins.conform-nvim.settings = {
              formatters_by_ft.sh = [ "shfmt" ];
              formatters.shfmt = {
                command = "${pkgs.shfmt}/bin/shfmt";
              };
            };

            extraPackages = with pkgs; [
              bash-language-server
              shfmt
            ];
          };
      };
    };
}
