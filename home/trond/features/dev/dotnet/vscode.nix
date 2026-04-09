{ pkgs, ... }:
{
  imports = [ ../../editors/vscode ];

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    ms-dotnettools.csdevkit
    ms-dotnettools.csharp
    ms-dotnettools.vscodeintellicode-csharp
  ];
}
