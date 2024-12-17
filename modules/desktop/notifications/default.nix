{
  lib,
  isLinux,
  ...
}:
{
  imports = lib.optionals isLinux [ ./_nixos.nix ];
}
