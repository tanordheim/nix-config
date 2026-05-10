{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bc
    ghostty.terminfo
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
