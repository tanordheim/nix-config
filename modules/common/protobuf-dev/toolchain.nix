{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          buf
          grpcurl
          protobuf
        ];
      }
    )
  ];
}
