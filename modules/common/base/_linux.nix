{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kitty.terminfo ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
