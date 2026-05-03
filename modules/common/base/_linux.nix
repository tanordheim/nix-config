{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty.terminfo
    usbutils
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
