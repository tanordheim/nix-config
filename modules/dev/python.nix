{
  flake.modules.homeManager.python-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.python-dev.enable {
        home.packages = with pkgs; [
          pipenv
          pyenv
          python3
          uv
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
      config = lib.mkIf (config.host.features.python-dev.enable && config.host.features.neovim.enable) (
        let
          pythonWithDebugpy = pkgs.python3.withPackages (ps: [ ps.debugpy ]);
        in
        {
          programs.nixvim = {
            plugins.treesitter.grammarPackages =
              with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
                python
              ];

            plugins.lsp.servers.basedpyright = {
              enable = true;
            };

            plugins.conform-nvim.settings = {
              formatters_by_ft.python = [
                "ruff_organize_imports"
                "ruff_format"
              ];
              formatters.ruff_format = {
                command = "${pkgs.ruff}/bin/ruff";
              };
              formatters.ruff_organize_imports = {
                command = "${pkgs.ruff}/bin/ruff";
              };
            };

            extraPackages = with pkgs; [
              basedpyright
              ruff
            ];

            extraPlugins = with pkgs.vimPlugins; [
              neotest-python
            ];

            plugins.neotest.settings.adapters = [
              {
                __raw = ''
                  require("neotest-python")({
                    runner = "pytest",
                  })
                '';
              }
            ];

            plugins.dap-python = {
              enable = true;
              settings.adapterPythonPath = "${pythonWithDebugpy}/bin/python";
            };
          };
        }
      );
    };

  flake.modules.homeManager.jetbrains =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.host.features.python-dev.enable && config.host.features.jetbrains.enable)
          (
            let
              versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.pycharm.version;

              vmOptionsFile =
                if pkgs.stdenv.isDarwin then
                  "Library/Application Support/JetBrains/Pycharm${versionMajorMinor}/pycharm.vmoptions"
                else
                  ".config/JetBrains/Pycharm${versionMajorMinor}/pycharm.vmoptions";

              vmOptionsContent =
                if pkgs.stdenv.isDarwin then
                  ''
                    -Xms1g
                    -Xmx2g
                  ''
                else
                  ''
                    -Xms1g
                    -Xmx2g
                    -Dawt.toolkit.name=WLToolkit
                  '';
            in
            {
              home = {
                packages = [ pkgs.bleeding.jetbrains.pycharm ];
                file = {
                  "${vmOptionsFile}".text = vmOptionsContent;
                };
              };

              jetbrains.ideavimConfigs.pycharm = ''
                " testing
                nnoremap <leader>tt :action ContextRun<CR>
                nnoremap <leader>ta :action RunClass<CR>
                nnoremap <leader>tl :action RerunTests<CR>
              '';
            }
          );
    };

  flake.modules.darwin.python-dev = { lib, ... }: { };
  flake.modules.nixos.python-dev = { lib, ... }: { };
}
