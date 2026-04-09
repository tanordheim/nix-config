{ pkgs, config, ... }:
{
  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        yaml
      ];

      plugins.lsp.servers.yamlls = {
        enable = true;
        cmd = [
          "${pkgs.yaml-language-server}/bin/yaml-language-server"
          "--stdio"
        ];
        settings = {
          keyOrdering = false;
          schemaStore = {
            enable = false;
            url = "";
          };
          schemas.__raw = ''require("schemastore").yaml.schemas()'';
        };
      };

      extraPackages = with pkgs; [
        yaml-language-server
      ];

      extraPlugins = with pkgs.vimPlugins; [
        SchemaStore-nvim
      ];
    };
}
