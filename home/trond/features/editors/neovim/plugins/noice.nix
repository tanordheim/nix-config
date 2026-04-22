{ pkgs, config, ... }:
{
  programs.nixvim.plugins.noice = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };
    settings = {
      messages.enabled = false; # using snacks
      views = {
        cmdline_popup.border.style = "rounded";
        hover.border.style = "rounded";
        # TODO evaluate popupmenu/confirm/mini borders later
      };
    };
  };
}
