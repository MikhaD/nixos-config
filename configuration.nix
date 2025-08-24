{ pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.

      ./programs/cli/bash.nix
      ./programs/cli/bat.nix
      ./programs/cli/git.nix
      ./programs/cli/neovim.nix
      ./programs/cli/python.nix
      ./programs/cli/ssh.nix
      ./programs/cli/wl-clipboard.nix

      ./programs/gui/firefox.nix

      ./system/bluetooth.nix
      ./system/boot.nix
      ./system/fonts.nix
      ./system/nvidia.nix

      ./services/keyd.nix

      ./programs/work.nix
    ];
  nix = {
    settings.auto-optimise-store = true; # Automatically hard link identical files in the Nix store to save space
    # Automatically run nix store garbage collection once a week
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d"; # Remove old generations older than 30 days
    };
  };
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; # creates "docker" alias for podman
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_ZA.UTF-8";
    LC_IDENTIFICATION = "en_ZA.UTF-8";
    LC_MEASUREMENT = "en_ZA.UTF-8";
    LC_MONETARY = "en_ZA.UTF-8";
    LC_NAME = "en_ZA.UTF-8";
    LC_NUMERIC = "en_ZA.UTF-8";
    LC_PAPER = "en_ZA.UTF-8";
    LC_TELEPHONE = "en_ZA.UTF-8";
    LC_TIME = "en_ZA.UTF-8";
  };

  # Temperature management daemon that prevents CPU overheating
  services.thermald.enable = true;
  # https://github.com/Mic92/envfs
  # services.envfs.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # enable xdg-desktop-portal to allow spectacle to take screenshots in wayland
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.mikha = {
    isNormalUser = true;
    description = "Mikha Davids";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [ # Add missing dynamic libraries here, not in environment.systemPackages
    #   stdenv.cc.cc.lib
    # ];
  };
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;
  programs.steam.enable = true;
  programs.tmux.enable = true;
  programs.obs-studio.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ########################## CLI Tools #########################
    curl
    exfat # Allow me to format drives as exfat (broad OS compatibility)
    fastfetch
    fzf
    lsd
    nodejs
    podman
    quickemu # May not need, probably a dep of quickgui
    quickgui
    tree
    #################### Desktop Applications ####################
    chromium
    # code-cursor
    flameshot
    freecad
    # kdePackages.spectacle
    # kdePackages.xdg-desktop-portal-kde
    libreoffice-qt
    obsidian
    pinta
    peek
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


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
}
