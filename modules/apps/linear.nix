{ inputs, ... }:
{
  flake.modules.darwin.linear =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.linear.enable {
        nix-homebrew.taps = {
          "schpet/homebrew-tap" = inputs.homebrew-schpet-tap;
        };

        homebrew = {
          casks = [ "linear-linear" ];
          brews = [ "schpet/tap/linear" ];
        };
      };
    };
}
