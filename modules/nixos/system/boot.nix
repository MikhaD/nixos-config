{
  lib,
  pkgs,
  ...
}: {
  # Bootloader
  boot = {
    kernelParams = ["quiet"];
    # TODO: Update to 6.17 as soon as it doesn't prevent booting on my hardware (6.17.2 was the last one that worked for me)
    # https://www.linuxlookup.com/linux_kernel
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_16;
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
