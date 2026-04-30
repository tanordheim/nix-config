{ inputs, ... }:
{
  nix-homebrew.taps = {
    "schpet/homebrew-tap" = inputs.homebrew-schpet-tap;
  };

  homebrew = {
    casks = [ "linear-linear" ];
    brews = [ "schpet/tap/linear" ];
  };
}
