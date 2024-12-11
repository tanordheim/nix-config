{ lib, isDarwin, ... }:
{
  imports = lib.optionals isDarwin [ ./_darwin.nix ];
}
