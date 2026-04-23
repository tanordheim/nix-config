{
  flake.modules.darwin.proton =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.proton.enable {
        homebrew.casks = [ "proton-mail" ];
      };
    };
}
