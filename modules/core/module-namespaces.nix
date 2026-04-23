{ lib, ... }:
{
  options.flake.modules = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        {
          freeformType = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
        }
      ];
    };
    default = { };
  };
}
