{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        c_sharp
      ];

      plugins.lsp.servers.omnisharp = {
        enable = true;
        extraOptions = {
          cmd = [
            "omnisharp"
            "--encoding"
            "utf-8"
            "--languageserver"
          ];
        };
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true;
            OrganizeImports = true;
          };
          MsBuild = {
            LoadProjectsOnDemand = true;
          };
        };
      };

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
    };
}
