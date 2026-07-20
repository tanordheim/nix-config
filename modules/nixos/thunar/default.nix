{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
    ];
  };

  programs.xfconf.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = [ pkgs.xarchiver ];
}
