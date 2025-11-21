{ pkgs, ... }:
{
  home-manager.users.${config.username}.home.pagkages = with pkgs; [
    whatsapp-for-mac
  ];
}
