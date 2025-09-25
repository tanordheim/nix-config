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
        ms-dotnettools.csharp
        vscodevim.vim
      ];
    };
  };
}
