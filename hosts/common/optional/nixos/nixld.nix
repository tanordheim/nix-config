{ pkgs, ... }:
{
  # support certain non-nix bundled programs that are dynamically linked
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # protobuf/grpc tools via nuget
      libgcc

      # run dotnet apps directly
      icu
      icu75
    ];
  };
}
