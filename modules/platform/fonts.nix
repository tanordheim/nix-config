{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.aporetic-bin
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.symbols-only
      ];
    };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.aporetic-bin
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.symbols-only
      ];
    };
}
