{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    k9s
    kubectl
    kubernetes-helm
    kustomize
  ];
}
