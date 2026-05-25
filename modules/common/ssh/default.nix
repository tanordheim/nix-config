{
  home-manager.sharedModules = [
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings."*" = { };
        settings."github.com" = {
          HostName = "ssh.github.com";
          Port = 443;
        };
      };
    }
  ];
}
