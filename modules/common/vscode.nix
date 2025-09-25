{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${config.username} = {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.vscodeintellicode-csharp
        vscodevim.vim
      ];
    };
  };
}
