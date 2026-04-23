{
  flake.modules.homeManager.qmk =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.qmk.enable {
        home.packages = [ pkgs.qmk ];
      };
    };

  flake.modules.nixos.qmk =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.qmk.enable {
        services.udev = {
          packages = [ pkgs.qmk-udev-rules ];
          extraRules = ''
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0142", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
          '';
        };
      };
    };
}
