{
  imports = [ ../claude ];

  home-manager.sharedModules = [
    { claude.sandbox.allowWrite = [ "~/.local/share/go/pkg/mod" ]; }
  ];
}
