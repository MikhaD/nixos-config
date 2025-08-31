{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.

    ./../../modules/nixos/programs/ssh.nix

    ./../../modules/nixos/desktop-environments/kde.nix
    ./../../modules/nixos/system/bluetooth.nix
    ./../../modules/nixos/system/boot.nix
    ./../../modules/nixos/system/fonts.nix
    ./../../modules/nixos/system/gc.nix
    ./../../modules/nixos/system/nvidia.nix
    ./../../modules/nixos/services/pipewire.nix
    ./../../modules/nixos/programs/podman.nix

    ./../../modules/nixos/services/keyd.nix

    ./../../modules/home-manager
    ./../../modules/nixos/system/user.nix
  ];

  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };

  default-user.enable = true;

  home-config = {
    enable = true;
    modules = [
      ./../../modules/home-manager/bash
      ./../../modules/home-manager/bat.nix
      ./../../modules/home-manager/chromium.nix
      ./../../modules/home-manager/fastfetch.nix
      ./../../modules/home-manager/git.nix
      ./../../modules/home-manager/neovim.nix
      ./../../modules/home-manager/nodejs.nix
      ./../../modules/home-manager/python.nix
      ./../../modules/home-manager/tree.nix
      # ./programs/cli/ssh.nix
      ./../../modules/home-manager/lsd.nix
      ./../../modules/home-manager/tmux
      ./../../modules/home-manager/wl-clipboard.nix
      ./../../modules/home-manager/xdg.nix

      ./../../modules/home-manager/firefox.nix

      ./../../modules/home-manager/work
    ];
    sessionVariables = {
      # Home directory cleanup
      BOTO_CONFIG = "$XDG_CONFIG_HOME/botorc"; # Removes .boto from ~
      ANDROID_USER_HOME = "$XDG_DATA_HOME/android"; # Removes .android/ from ~
      MAVEN_OPTS = "-Duser.home=$XDG_DATA_HOME/maven"; # Removes .m2/ from ~
      JAVA_USER_HOME = "$XDG_DATA_HOME/java"; # Removes .java/ from ~
      GOPATH = "$XDG_DATA_HOME/go"; # Removes go/ from ~
      LESSHISTFILE = "$XDG_STATE_HOME/lesshst"; # Removes .lesshst from ~
      WGETRC = "$XDG_DATA_HOME/wget-hsts"; # Removes .wget-hsts from ~
    };
  };

  i18n.extraLocaleSettings = {
    LC_NUMERIC = "en_US.UTF-8";
  };

  # Temperature management daemon that prevents CPU overheating
  services.thermald.enable = true;
  # https://github.com/Mic92/envfs
  # services.envfs.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment.variables = {
    GTK_USE_PORTAL = 1;
  };

  # https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [ # Add missing dynamic libraries here, not in environment.systemPackages
    #   stdenv.cc.cc.lib
    # ];
  };

  programs.steam.enable = true;
  programs.obs-studio.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ########################## CLI Tools #########################
    alejandra
    curl
    exfat # Allow me to format drives as exfat (broad OS compatibility)
    # quickemu # May not need, probably a dep of quickgui
    quickgui
    #################### Desktop Applications ####################
    # code-cursor
    freecad
    libreoffice-qt
    obsidian
    pinta
    rofi-wayland
    stremio
    vscode

    # keyd # I think this is installed if the service is enabled above
    nixd
    scrcpy
    ################ Required for kickstart.nvim #################
    gnumake
    libgcc
    lua
    ripgrep
    unzip
  ];

  system.stateVersion = "24.05"; # DO NOT CHANGE
}
