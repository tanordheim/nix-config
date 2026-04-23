{
  flake.modules.darwin.base = {
    security.sudo.extraConfig = ''
      Defaults lecture = never
      Defaults timestamp_timeout=30
    '';
  };

  flake.modules.nixos.base = {
    security.sudo.extraConfig = ''
      Defaults lecture = never
      Defaults timestamp_timeout=30
    '';
  };
}
