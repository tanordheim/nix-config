{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      yaml-language-server
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
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
        schemas = {
          kubernetes = [
            "k8s/*.yaml"
            "manifest/*.yaml"
          ];
          "http://json.schemastore.org/golangci-lint.json" = ".golangci.{yml,yaml}";
          "http://json.schemastore.org/github-workflow.json" = ".github/workflows/*.{yml,yaml}";
          "http://json.schemastore.org/github-action.json" = ".github/action.{yml,yaml}";
          "http://json.schemastore.org/ansible-stable-2.9.json" = "roles/tasks/*.{yml,yaml}";
          "http://json.schemastore.org/ansible-playbook.json" = "playbook.{yml,yaml}";
          "http://json.schemastore.org/prettierrc.json" = ".prettierrc.{yml,yaml}";
          "http://json.schemastore.org/stylelintrc.json" = ".stylelintrc.{yml,yaml}";
          "http://json.schemastore.org/circleciconfig.json" = ".circleci/**/*.{yml,yaml}";
          "http://json.schemastore.org/kustomization.json" = "kustomization.{yml,yaml}";
          "http://json.schemastore.org/helmfile.json" = "templates/**/*.{yml,yaml}";
          "http://json.schemastore.org/chart.json" = "Chart.yml,yaml}";
          "http://json.schemastore.org/gitlab-ci.json" = "/*lab-ci.{yml,yaml}";
          "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json" =
            "templates/**/*.{yml,yaml}";
          "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
            "docker-compose.{yml,yaml}";
        };
      };
    };
  };
}
