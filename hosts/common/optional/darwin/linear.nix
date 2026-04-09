{ homebrew-schpet-tap, ... }:
{
  nix-homebrew.taps = {
    "schpet/homebrew-tap" = homebrew-schpet-tap;
  };

  homebrew = {
    casks = [ "linear-linear" ];
    brews = [ "schpet/tap/linear" ];
  };
}
