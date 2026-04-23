{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.nixos = lib.mkOption {
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

  config.flake.nixosConfigurations = lib.mkIf (config.configurations.nixos != { }) (
    lib.mapAttrs (
      _: cfg:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ cfg.module ];
        specialArgs = { inherit inputs; };
      }
    ) config.configurations.nixos
  );
}
