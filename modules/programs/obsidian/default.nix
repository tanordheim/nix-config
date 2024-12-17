{
  lib,
  isDarwin,
  isLinux,
  ...
}:
{
  imports = [ ] ++ lib.optional isDarwin ./_darwin.nix ++ lib.optional isLinux ./_nixos.nix;
}
