{ inputs, ... }:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "aarch64-linux";
  specialArgs = inputs;
  modules =
    [
      inputs.apple-silicon-support.nixosModules.apple-silicon-support
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      ../../modules/linux
      ./hardware-configuration.nix
      {
        networking.hostName = "harahorn";
        networking.networkmanager.enable = true;

        hardware = {
          asahi = {
            peripheralFirmwareDirectory = /boot/asahi;
            useExperimentalGPUDriver = true;
            experimentalGPUInstallMode = "replace";
            setupAsahiSound = true;
          };
          graphics = {
            enable = true;
          };
        };
      }
    ]
    ++ (builtins.attrValues inputs.nix-config-private.outputs.homeManagerModules)
    ++ (builtins.attrValues inputs.nix-config-private.outputs.nixModules);
}
