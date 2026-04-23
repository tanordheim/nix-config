{
  flake.modules.darwin.docker =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.docker.enable {
        homebrew.casks = [ "docker-desktop" ];
        environment.systemPackages = [ pkgs.docker-compose ];
      };
    };

  flake.modules.nixos.docker =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.docker.enable {
        virtualisation.docker.enable = true;
        environment.systemPackages = [ pkgs.docker-compose ];
      };
    };
}
