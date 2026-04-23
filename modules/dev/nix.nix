{
  flake.modules.homeManager.nix-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.nix-dev.enable {
        home.packages = with pkgs; [
          nixfmt
          nvd
        ];
      };
    };

  flake.modules.homeManager.neovim =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.nix-dev.enable && config.host.features.neovim.enable) {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              nix
            ];
          plugins.lsp.servers.nil_ls.enable = true;
          plugins.conform-nvim.settings = {
            formatters_by_ft.nix = [ "nixfmt" ];
            formatters.nixfmt.command = "${pkgs.nixfmt}/bin/nixfmt";
          };
          plugins.lint.lintersByFt.nix = [ "statix" ];
          extraPackages = with pkgs; [
            nil
            statix
          ];
        };
      };
    };

  flake.modules.darwin.nix-dev = { lib, ... }: { };
  flake.modules.nixos.nix-dev = { lib, ... }: { };
}
