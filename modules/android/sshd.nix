# https://github.com/nix-community/nix-on-droid/wiki/SSH-access
{
  config,
  lib,
  ...
}: let
  cfg = config.sshd;
in {
  options.sshd = {};
  config = {
    build.activation.sshd = ''

    '';
  };
}
