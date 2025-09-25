{
  pkgs,
  config,
  ...
}:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      vscodevim.vim
    ];
  };
}
