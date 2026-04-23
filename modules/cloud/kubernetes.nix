{ inputs, ... }:
{
  flake.modules.homeManager.kubernetes =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.kubernetes.enable {
        home.packages = with pkgs; [
          k9s
          kubectl
          kubernetes-helm
          kustomize
        ];
      };
    };

  flake.modules.darwin.kubernetes =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.kubernetes.enable {
        nix-homebrew.taps = {
          "telepresenceio/homebrew-telepresence" = inputs.homebrew-telepresence;
        };
        homebrew.brews = [ "telepresenceio/telepresence/telepresence-oss" ];
      };
    };
}
