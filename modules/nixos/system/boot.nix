{
  lib,
  pkgs,
  ...
}: {
  # Bootloader
  boot = {
    kernelParams = ["quiet"];
    # https://www.linuxlookup.com/linux_kernel (latest kernel versions)
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
# take a look at this at some point: https://github.com/alex-bartleynees/nix-config/blob/0cc3c3332a7c27ea135a1f1ba30a58c9d3843d99/modules/silent-boot.nix

