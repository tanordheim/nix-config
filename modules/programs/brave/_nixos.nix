{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brave.brave
  ];

  my.user.xdg.desktopEntries.brave-browser = {
    exec = "brave --enable-features=UseOzonePlatform,Vulkan,VulkanFromANGLE,DefaultANGLEVulka --ozone-platform=wayland --use-gl=angle --use-angle=vulkan";
    icon = "brave";
    name = "Brave";
    terminal = false;
    type = "Application";
  };
}
