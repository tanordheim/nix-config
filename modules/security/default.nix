{ lib, isDarwin, ... }:
{
  security.sudo.extraConfig = ''
    Defaults lecture = never
    Defaults timestamp_timeout=30
  '';

  imports = lib.optionals isDarwin [ ./_darwin.nix ];
}
