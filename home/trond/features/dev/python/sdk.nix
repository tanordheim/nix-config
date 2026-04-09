{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pipenv
    pyenv
    python3
    uv
  ];
}
