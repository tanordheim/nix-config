{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.iosevka-custom-nerd
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.symbols-only
      ];
    };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.iosevka-custom-nerd
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.symbols-only
      ];
    };
}
