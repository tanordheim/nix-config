{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.darwin = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
        };
      }
    );
    default = { };
  };

  config.flake.darwinConfigurations = lib.mkIf (config.configurations.darwin != { }) (
    lib.mapAttrs (
      _: cfg:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [ cfg.module ];
        specialArgs = { inherit inputs; };
      }
    ) config.configurations.darwin
  );
}
