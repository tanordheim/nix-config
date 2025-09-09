{ nix-homebrew, homebrew-telepresence, ... }:
{
  nix-homebrew.taps = {
    "telepresenceio/homebrew-telepresence" = homebrew-telepresence;
  };

  homebrew.brews = [
    "telepresenceio/telepresence/telepresence-oss"
  ];
}
