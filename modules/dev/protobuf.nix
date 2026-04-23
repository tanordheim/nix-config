{
  flake.modules.homeManager.protobuf-dev = { lib, ... }: { };

  flake.modules.homeManager.neovim =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.protobuf-dev.enable && config.host.features.neovim.enable) {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              proto
            ];

          plugins.lsp.servers.protols = {
            enable = true;
            cmd = [ "${pkgs.protols}/bin/protols" ];
          };

          plugins.conform-nvim.settings = {
            formatters_by_ft.proto = [ "buf" ];
            formatters.buf = {
              command = "${pkgs.buf}/bin/buf";
            };
          };

          extraPackages = with pkgs; [
            buf
            protols
          ];
        };
      };
    };

  flake.modules.darwin.protobuf-dev = { lib, ... }: { };
  flake.modules.nixos.protobuf-dev = { lib, ... }: { };
}
