{
  lib,
  pkgs,
  ...
}: {
  # Bootloader
  boot = {
    kernelParams = ["quiet"];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8; # Keep last 8 nixos generations in bootloader menu
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1; # Only show nix derivation selector for 1 second
    };
    # plymouth.enable = true;
  };
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Don't wait for network manager to establish a connection during boot
}
