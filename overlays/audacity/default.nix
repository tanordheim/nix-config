{ ... }:
final: prev: {
  # WORKAROUND: hardened ld64 SIGTRAPs ("Trace/BPT trap: 5") linking audacity
  # on aarch64-darwin; revert pending in staging-next,
  # https://github.com/NixOS/nixpkgs/pull/536365
  audacity = final.stable.audacity;
}
