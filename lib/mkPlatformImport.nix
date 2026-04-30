dir: pkgs: if pkgs.stdenv.isDarwin then dir + "/_darwin.nix" else dir + "/_linux.nix"
