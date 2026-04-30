{ inputs, ... }:
{
  nix-homebrew.taps = {
    "telepresenceio/homebrew-telepresence" = inputs.homebrew-telepresence;
  };
  homebrew.brews = [ "telepresenceio/telepresence/telepresence-oss" ];

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
