{ ... }:
final: prev: {
  vscode-extensions = prev.vscode-extensions // {
    ms-dotnettools = prev.vscode-extensions.ms-dotnettools // {
      # WORKAROUND: bash 5.3 subshell LANG=C segfault on darwin breaks
      # isMachO in fixup, misclassifying PE dlls and chmod-ing the read-only
      # .roslynCopilot store path, https://github.com/NixOS/nixpkgs/issues/431934
      csharp = prev.vscode-extensions.ms-dotnettools.csharp.overrideAttrs (_: {
        LANG = "C";
      });
    };
  };
}
