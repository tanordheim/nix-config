{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      gopls
    ];

    plugins.lsp.servers.gopls = {
      enable = true;
      settings = {
        gopls = {
          analyses = {
            unusedparams = true;
            unusedvariable = true;
            unusedwrite = true;
            useany = true;
          };
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
          semanticTokens = true;
          staticcheck = true;
        };
      };
    };
  };
}
