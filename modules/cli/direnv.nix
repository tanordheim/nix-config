{
  flake.modules.homeManager.base = {
    programs.direnv = {
      enable = true;
      enableFishIntegration = false;
      enableNushellIntegration = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
