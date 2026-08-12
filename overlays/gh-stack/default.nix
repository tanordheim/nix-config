{ ... }:
final: prev: {
  # WORKAROUND: gh-stack is absent from nixpkgs; remove this package and use
  # pkgs.gh-stack once it lands upstream.
  gh-stack = prev.buildGoModule rec {
    pname = "gh-stack";
    version = "0.1.0";

    src = prev.fetchFromGitHub {
      owner = "github";
      repo = "gh-stack";
      rev = "v${version}";
      hash = "sha256-48JkOeqbvHlCZ2u3LnwJymw55xMQWLTPJLDbV44clGI=";
    };

    vendorHash = "sha256-0Xtr/MOpX4u5GnbRdNxKPA0GpSzi8PIbVc9MmP05De4=";

    ldflags = [ "-X=github.com/github/gh-stack/cmd.Version=${version}" ];

    nativeCheckInputs = [ prev.gitMinimal ];

    meta = {
      description = "GitHub CLI extension for managing stacked pull requests";
      homepage = "https://github.com/github/gh-stack";
      license = prev.lib.licenses.mit;
      mainProgram = "gh-stack";
    };
  };
}
