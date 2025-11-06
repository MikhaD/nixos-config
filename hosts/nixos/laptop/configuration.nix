{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.

    ./../../../modules/nixos/programs/ssh.nix

    ./../../../modules/nixos/desktop-environments/kde.nix
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

    ./../../../modules/home-manager
    ./../../../modules/nixos/system/user.nix
  ];

  default-user.enable = true;

  home-config = {
    enable = true;
    modules = [
      ./../../../modules/home-manager/bash
      ./../../../modules/home-manager/bat.nix
      ./../../../modules/home-manager/chromium.nix
      ./../../../modules/home-manager/dig.nix
      ./../../../modules/home-manager/fastfetch.nix
      ./../../../modules/home-manager/fzf.nix
      ./../../../modules/home-manager/git.nix
      ./../../../modules/home-manager/grep.nix
      ./../../../modules/home-manager/jq.nix
      ./../../../modules/home-manager/neovim.nix
      ./../../../modules/home-manager/nh
      ./../../../modules/home-manager/nodejs.nix
      ./../../../modules/home-manager/obs.nix
      ./../../../modules/home-manager/obsidian
      ./../../../modules/home-manager/python.nix
      ./../../../modules/home-manager/tree.nix
      ./../../../modules/home-manager/lsd.nix
      ./../../../modules/home-manager/sops.nix
      ./../../../modules/home-manager/tmux
      # ./../../../modules/home-manager/ulauncher
      ./../../../modules/home-manager/wl-clipboard.nix
      ./../../../modules/home-manager/xdg.nix

      ./../../../modules/home-manager/firefox.nix

      ./../../../modules/home-manager/work
    ];
    sessionVariables = {
      # BOTO_CONFIG = "${config.xdg.configHome}/botorc"; # Removes .boto from ~
      # ANDROID_USER_HOME = "${config.xdg.dataHome}/android"; # Removes .android/ from ~
    };
  };

  # https://github.com/Mic92/envfs
  # services.envfs.enable = true;

  services.printing.enable = false;

  environment.variables = {
    GTK_USE_PORTAL = 1;
  };

  environment.systemPackages = with pkgs; [
    ########################## CLI Tools #########################
    curl
    exfat # Allow me to format drives as exfat (broad OS compatibility)
    figlet
    #################### Desktop Applications ####################
    bruno
    # code-cursor
    freecad
    libreoffice-qt
    pinta
    quickgui
    scrcpy
    # stremio # depends on insecure library
    vscode
    ################ Required for kickstart.nvim #################
    gnumake
    gcc
    lua
    ripgrep
    unzip
  ];

  system.stateVersion = "24.05"; # DO NOT CHANGE
}
