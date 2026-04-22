{ pkgs, config, ... }:
{
  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        yaml
      ];

      filetype = {
        filename = {
          "docker-compose.yml" = "yaml.docker-compose";
          "docker-compose.yaml" = "yaml.docker-compose";
          "compose.yml" = "yaml.docker-compose";
          "compose.yaml" = "yaml.docker-compose";
          ".gitlab-ci.yml" = "yaml.gitlab";
          "Chart.yaml" = "yaml.helm-values";
          "Chart.yml" = "yaml.helm-values";
        };
        pattern = {
          ".*/templates/.*%.ya?ml" = "yaml.helm-values";
          ".*/values%.ya?ml" = "yaml.helm-values";
        };
      };

      extraConfigLua = # lua
        ''
          vim.treesitter.language.register('yaml', 'yaml.docker-compose')
          vim.treesitter.language.register('yaml', 'yaml.gitlab')
          vim.treesitter.language.register('yaml', 'yaml.helm-values')
        '';

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
