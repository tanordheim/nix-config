{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pipenv
    pyenv
    python3
  ];
}
