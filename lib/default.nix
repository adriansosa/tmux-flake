{ pkgs }:
{
  inherit (pkgs.lib);
  mkTmux = import ./mkTmux.nix { inherit pkgs; };
  mkTmuxPlugin = import ./mkTmuxPlugin.nix { inherit pkgs; };
}
