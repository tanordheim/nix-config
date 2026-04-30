{
  imports = [ ../../modules/_new/darwin/_base.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  networking.hostName = "lyng";
  home-manager.users.trond.home.stateVersion = "24.11";
}
