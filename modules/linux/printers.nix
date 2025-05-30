{ pkgs, ... }:
{
  services.printing.enable = true;
  services.system-config-printer.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
