{ aurral-src, ... }:
final: prev:
let
  version = "1.50.1";
  src = aurral-src;

  frontend = prev.buildNpmPackage {
    pname = "aurral-frontend";
    inherit version;
    src = "${aurral-src}/frontend";
    npmDepsHash = prev.lib.fakeHash;

    env = {
      VITE_APP_VERSION = version;
      VITE_GITHUB_REPO = "lklynet/aurral";
      VITE_RELEASE_CHANNEL = "stable";
    };

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  backend = prev.buildNpmPackage {
    pname = "aurral-backend";
    inherit version;
    src = "${aurral-src}/backend";
    npmDepsHash = prev.lib.fakeHash;

    dontNpmBuild = true;
    npmFlags = [ "--omit=dev" ];

    nativeBuildInputs = with prev; [
      python3
      pkg-config
      nodejs
      node-gyp
    ];
    buildInputs = with prev; [ vips ];

    env = {
      npm_config_nodedir = prev.nodejs;
      npm_config_sharp_binary_host = "";
      npm_config_sharp_libvips_binary_host = "";
      NODE_PATH = "${prev.node-gyp}/lib/node_modules";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';
  };

  rootDeps = prev.buildNpmPackage {
    pname = "aurral-root-deps";
    inherit version;
    src = prev.runCommand "aurral-root-src" { } ''
      mkdir -p $out
      cp ${aurral-src}/package.json ${aurral-src}/package-lock.json $out/
    '';
    npmDepsHash = prev.lib.fakeHash;

    dontNpmBuild = true;
    npmFlags = [
      "--omit=dev"
      "--ignore-scripts"
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/
      runHook postInstall
    '';
  };
in
{
  aurral = prev.stdenv.mkDerivation {
    pname = "aurral";
    inherit version src;

    nativeBuildInputs = [ prev.makeWrapper ];
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/aurral
      cp server.js loadEnv.js package.json $out/share/aurral/
      cp -r backend $out/share/aurral/

      mkdir -p $out/share/aurral/frontend
      ln -s ${frontend} $out/share/aurral/frontend/dist

      ln -s ${rootDeps}/node_modules $out/share/aurral/node_modules
      ln -s ${backend}/node_modules $out/share/aurral/backend/node_modules

      mkdir -p $out/bin
      makeWrapper ${prev.nodejs}/bin/node $out/bin/aurral \
        --add-flags "$out/share/aurral/server.js" \
        --chdir "$out/share/aurral"

      runHook postInstall
    '';

    meta = {
      description = "Artist Discovery and Request Manager for Lidarr";
      homepage = "https://github.com/lklynet/aurral";
      license = prev.lib.licenses.mit;
      platforms = prev.lib.platforms.linux;
      mainProgram = "aurral";
    };
  };
}
