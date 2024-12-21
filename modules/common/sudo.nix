{ lib, ... }:
{
  security.sudo = {
    enable = true;

    extraConfig = ''
      Defaults lecture = never
      Defaults timestamp_timeout=30
    '';
  };
}
