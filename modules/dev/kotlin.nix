{
  flake.modules.homeManager.kotlin-dev = { lib, ... }: { };

  flake.modules.homeManager.neovim =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.kotlin-dev.enable && config.host.features.neovim.enable) {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              kotlin
            ];

          plugins.lsp.servers.kotlin_language_server = {
            enable = true;
          };

          plugins.conform-nvim.settings = {
            formatters_by_ft.kotlin = [ "ktlint" ];
            formatters.ktlint = {
              command = "${pkgs.ktlint}/bin/ktlint";
            };
          };

          plugins.lint.lintersByFt = {
            kotlin = [ "ktlint" ];
          };

          extraPackages = with pkgs; [
            kotlin-language-server
            ktlint
          ];
        };
      };
    };

  flake.modules.darwin.kotlin-dev = { lib, ... }: { };
  flake.modules.nixos.kotlin-dev = { lib, ... }: { };
}
