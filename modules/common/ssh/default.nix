{
  home-manager.sharedModules = [
    (
      { lib, ... }:
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

        home.activation.copySshConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ -L "$HOME/.ssh/config" ]; then
            src=$(readlink -f "$HOME/.ssh/config")
            rm "$HOME/.ssh/config"
            run install -m 600 "$src" "$HOME/.ssh/config"
          fi
        '';
      }
    )
  ];
}
