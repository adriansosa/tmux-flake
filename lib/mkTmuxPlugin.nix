mkTmuxPlugin: { pkgs, stdenv, ...}:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "";
  version = "";

  outputs = [];

  src = pkgs.fetchFromGitHub {
  };

  patches = [
    (pkgs.fetchpatch {
      url = "";
      sha256 = "";
    })
  ];
}
