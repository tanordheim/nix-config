{ inputs, ... }:
let
  commonPackages =
    pkgs: with pkgs; [
      coreutils
      curl
      diffutils
      file
      findutils
      gawk
      gnugrep
      gnused
      gnutar
      gzip
      jq
      killall
      lsof
      tree
      unzip
      zip
    ];
in
{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = commonPackages pkgs;
      programs.zsh.enable = true;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
      };
    };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = (commonPackages pkgs) ++ [ pkgs.kitty.terminfo ];
      programs.zsh.enable = true;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
      };

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    };
}
