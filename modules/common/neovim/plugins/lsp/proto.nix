{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      protols
    ];

    plugins.lsp.servers.protols = {
      enable = true;
      cmd = [ "${pkgs.protols}/bin/protols" ];
    };
  };
}
