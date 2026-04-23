{
  flake.modules.homeManager.aws =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.aws.enable {
        programs.awscli.enable = true;
      };
    };
}
