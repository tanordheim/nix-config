{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice-bin
  ];
}
