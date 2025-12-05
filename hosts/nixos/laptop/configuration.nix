{...}: {
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.

    ./../../../modules/nixos/programs/ssh.nix

    ./../../../modules/nixos/desktop-environments/kde.nix
    # ./../../../modules/nixos/desktop-environments/hyprland.nix
    ./../../../modules/nixos/system/bluetooth.nix
    ./../../../modules/nixos/system/boot.nix
    ./../../../modules/nixos/system/fonts.nix
    ./../../../modules/nixos/system/nvidia.nix
    ./../../../modules/nixos/programs/nix-ld.nix
    ./../../../modules/nixos/programs/podman.nix
    ./../../../modules/nixos/programs/steam.nix
    ./../../../modules/nixos/system/store.nix

    ./../../../modules/nixos/services/keyd
    ./../../../modules/nixos/services/pipewire.nix
    ./../../../modules/nixos/services/thermald.nix

    # ./../../../modules/home-manager
    ./../../../modules/nixos/system/user.nix
  ];

  default-user.enable = true;

  # https://github.com/Mic92/envfs
  # services.envfs.enable = true;

  services.printing.enable = false;

  environment.variables = {
    GTK_USE_PORTAL = 1;
  };

  system.stateVersion = "24.05"; # DO NOT CHANGE
}
