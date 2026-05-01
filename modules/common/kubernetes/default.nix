{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          k9s
          kubectl
          kubernetes-helm
          kustomize
        ];
      }
    )
  ];
}
