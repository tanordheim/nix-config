{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bc
    kitty.terminfo
    openssl
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
