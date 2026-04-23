{
  flake.modules.darwin.obsidian =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.obsidian.enable {
        homebrew.casks = [ "obsidian" ];
      };
    };
}
