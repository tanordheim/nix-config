{ pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform
    tflint
  ];
}
