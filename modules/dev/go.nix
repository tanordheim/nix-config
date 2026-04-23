{
  flake.modules.homeManager.go-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.go-dev.enable {
        programs.go = {
          enable = true;
          package = pkgs.go;

          env = {
            GOPATH = "${config.home.homeDirectory}/.local/share/go";
            GOBIN = "${config.home.homeDirectory}/.local/bin";
            GOPRIVATE = [
              "github.com/tanordheim"
            ];
          };
        };

        home.packages = with pkgs; [
          golangci-lint
          gotools
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
      config = lib.mkIf (config.host.features.go-dev.enable && config.host.features.neovim.enable) {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              go
              gomod
              gosum
            ];

          filetype = {
            filename = {
              "go.work" = "gowork";
            };
            pattern = {
              ".*%.gotmpl" = "gotmpl";
            };
          };

          plugins.lsp.servers.gopls = {
            enable = true;
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true;
                  unusedvariable = true;
                  unusedwrite = true;
                  useany = true;
                };
                hints = {
                  assignVariableTypes = false;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = false;
                  constantValues = true;
                  functionTypeParameters = false;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
                gofumpt = true;
                usePlaceholders = true;
                semanticTokens = true;
                staticcheck = true;
                codelenses = {
                  generate = true;
                  gc_details = false;
                  regenerate_cgo = false;
                  run_govulncheck = true;
                  test = true;
                  tidy = true;
                  upgrade_dependency = true;
                  vendor = true;
                };
              };
            };
          };

          plugins.lsp.servers.golangci_lint_ls = {
            enable = true;
            settings = {
              cmd = [ pkgs.golangci-lint-langserver ];
              init_options = {
                command = [
                  pkgs.golangci-lint
                  "run"
                  "--out-format"
                  "json"
                ];
              };
            };
          };

          plugins.conform-nvim = {
            settings.formatters_by_ft.go = [ "gofumpt" ];
            settings.formatters.gofumpt = {
              command = "${pkgs.gofumpt}/bin/gofumpt";
            };
          };

          extraPackages = with pkgs; [
            delve
            golangci-lint-langserver
            gopls
            gofumpt
          ];

          extraPlugins = with pkgs.vimPlugins; [
            neotest-golang
          ];

          plugins.neotest.settings.adapters = [
            {
              __raw = ''
                require("neotest-golang")({})
              '';
            }
          ];

          plugins.dap-go = {
            enable = true;
            settings.delve.path = "${pkgs.delve}/bin/dlv";
          };
        };
      };
    };

  flake.modules.homeManager.jetbrains =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.go-dev.enable && config.host.features.jetbrains.enable) (
        let
          versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.datagrip.version;

          vmOptionsFile =
            if pkgs.stdenv.isDarwin then
              "Library/Application Support/JetBrains/GoLand${versionMajorMinor}/goland.vmoptions"
            else
              ".config/JetBrains/GoLand${versionMajorMinor}/goland64.vmoptions";

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
            packages = [ pkgs.bleeding.jetbrains.goland ];

            file = {
              "${vmOptionsFile}".text = vmOptionsContent;
            };
          };

          jetbrains.ideavimConfigs.goland = ''
            " testing
            nnoremap <leader>tt :action ContextRun<CR>
            nnoremap <leader>ta :action RunClass<CR>
            nnoremap <leader>tl :action RerunTests<CR>
          '';
        }
      );
    };

  flake.modules.darwin.go-dev = { lib, ... }: { };
  flake.modules.nixos.go-dev = { lib, ... }: { };
}
