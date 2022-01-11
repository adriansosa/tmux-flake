{ pkgs,  config,  lib, ... }:
with lib;
with builtins;
let
  cfg = "testing";
in {
  something  = "something else";
}
