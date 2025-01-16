{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      basedpyright
    ];

    plugins.lsp.servers.basedpyright = {
      enable = true;
      cmd = [
        "${pkgs.basedpyright}/bin/basedpyright-langserver"
        "--stdio"
      ];
    };
  };
}
