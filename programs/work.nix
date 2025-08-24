{ pkgs, ... }:
let
    gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
        cloud-datastore-emulator
    ]);
in
{
  imports = [
    ./cli/terraform.nix
  ];

  environment.variables = {
    # TODO: Should be in a nix-env for the thing that needs it (here at the moment to get nix shell created poetry installs to work in pycharm)
    # https://discourse.nixos.org/t/what-package-provides-libstdc-so-6/18707/2
    LD_LIBRARY_PATH = "/run/current-system/sw/lib:$LD_LIBRARY_PATH";
  };

  environment.systemPackages = with pkgs; [
    bruno
    gdk
    google-cloud-sql-proxy
    jdk
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    ngrok
    pgloader
    poetry
    stdenv.cc.cc.lib
  ];
}