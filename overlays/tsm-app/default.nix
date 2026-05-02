{ tsm-app-linux-src, ... }:
final: prev:
let
  py = prev.python3Packages;

  apscheduler4 = py.buildPythonPackage rec {
    pname = "apscheduler";
    version = "4.0.0a6";
    pyproject = true;

    src = prev.fetchPypi {
      pname = "apscheduler";
      inherit version;
      hash = "sha256-UTRhfAKPCX3koJq77vxCYlywzjrctM5J10zCYFQIR2E=";
    };

    build-system = [
      py.setuptools
      py.setuptools-scm
    ];

    dependencies = with py; [
      anyio
      attrs
      tenacity
      tzlocal
    ];

    doCheck = false;
    pythonImportsCheck = [ "apscheduler" ];
  };
in
{
  tsm-app = py.buildPythonApplication {
    pname = "tsm-app";
    version = "master";
    pyproject = true;

    src = tsm-app-linux-src;

    env.SETUPTOOLS_SCM_PRETEND_VERSION = "1.1.6";

    build-system = with py; [
      hatchling
      hatch-vcs
    ];

    dependencies = (with py; [
      pyside6
      aiohttp
      pydantic
      aiosqlite
      keyring
      structlog
      tomli-w
      pyyaml
      typing-extensions
    ]) ++ [ apscheduler4 ];

    dontWrapQtApps = false;

    postInstall = ''
      install -Dm644 packaging/tsm-app.desktop \
        $out/share/applications/tsm-app.desktop
      for size in 16 32 48 128 256; do
        install -Dm644 tsm/ui/assets/tsm_$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/tsm-app.png
      done
    '';

    meta = {
      description = "TradeSkillMaster Desktop App for Linux (auction data sync for WoW under Wine)";
      homepage = "https://github.com/exceptionptr/tsm-app-linux";
      license = prev.lib.licenses.mit;
      platforms = prev.lib.platforms.linux;
      mainProgram = "tsm-app";
    };
  };
}
