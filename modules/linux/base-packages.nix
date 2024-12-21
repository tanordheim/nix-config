{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    asahi-bless
  ];
}
