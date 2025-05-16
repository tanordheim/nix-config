{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qmk
  ];

  services.udev = {
    packages = with pkgs; [
      qmk-udev-rules
    ];

    # needed for VIA
    extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0142", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
