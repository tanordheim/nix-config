{ inputs, ... }:
{
  nix-homebrew.taps = {
    "schpet/homebrew-tap" = inputs.homebrew-schpet-tap;
  };

  homebrew = {
    casks = [ "linear" ];
    brews = [ "schpet/tap/linear" ];
  };
}
