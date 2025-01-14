{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      vscode-langservers-extracted
    ];

    plugins.lsp.servers.html = {
      enable = true;
      cmd = [
        "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server"
        "--stdio"
      ];
    };
  };
}
