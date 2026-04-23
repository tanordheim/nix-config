{
  flake.modules.homeManager.base = {
    programs.starship = {
      enable = true;
      settings = {
        docker_context.disabled = true;
        gcloud.disabled = true;
      };
    };
  };
}
