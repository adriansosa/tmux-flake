{
  description = "Tmux flake by adriansosa";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";

    tmux = {
      url = "github:tmux/tmux/3.2a";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, flake-utils, ...}:
  flake-utils.lib.eachDefaultSystem (system:
  let 
    pkgs = nixpkgs.legacyPackages.${system};
    utils = import ./lib { inherit pkgs; };
    plugins = [ "tmux-thumbs" ];
  in
  rec {

    packages = flake-utils.lib.flattenTree {
      tmux = pkgs.tmux;
    };

    defaultPackage = utils.mkTmux { inherit pkgs; };

    apps.tmux = flake-utils.lib.mkApp { drv = packages.tmux; };
    defaultApp = apps.tmux;
    devShell = pkgs.mkShell {
      shellHook = ''
        eval "$(starship init bash)"
      '';
      buildInputs = [ pkgs.tmux ];
    };
  }
  );
}
