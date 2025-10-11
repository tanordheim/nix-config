{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    stable.awscli2
  ];
}
