{ ... }:
{
  programs.nixvim = {
    plugins.lint = {
      enable = true;
    };
  };
}
