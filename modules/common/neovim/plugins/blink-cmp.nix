{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.blink-cmp = {
    enable = true;

    settings = {
      keymap = {
        preset = "super-tab";
      };
      appearance = {
        use_nvim_cmp_as_default = true;
        nerd_font_variant = "mono";
      };
      completion.trigger.show_in_snippet = false;
      signature.enabled = true;
    };
  };
}
