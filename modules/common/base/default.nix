{
  lib,
  isDarwin,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  environment.systemPackages = with pkgs; [
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

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
}
