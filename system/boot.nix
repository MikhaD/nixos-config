{ lib, ... }:
{
  # Bootloader
  boot = {
    kernelParams = [ "quiet" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1; # Only show nix derivation selector for 1 second
    };
    # plymouth.enable = true;
  };
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Don't wait for network manager to establish a connection during boot
}