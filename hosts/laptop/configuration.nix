{ pkgs, inputs, details, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix # Include the results of the hardware scan.

    ./../../modules/nixos/programs/ssh.nix

    ./../../modules/nixos/system/bluetooth.nix
    ./../../modules/nixos/system/boot.nix
    ./../../modules/nixos/system/fonts.nix
    ./../../modules/nixos/system/nvidia.nix

    ./../../modules/nixos/services/keyd.nix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit details; };
    users.${details.username} = {
      imports = [
        ./../../modules/home-manager/bash
        ./../../modules/home-manager/bat.nix
        ./../../modules/home-manager/git.nix
        ./../../modules/home-manager/neovim.nix
        ./../../modules/home-manager/python.nix
        # ./programs/cli/ssh.nix
        ./../../modules/home-manager/tmux
        ./../../modules/home-manager/wl-clipboard.nix

        ./../../modules/home-manager/firefox.nix

        ./../../modules/home-manager/work
      ];
      programs.chromium.enable = true;
      home = {
        username = details.username;
        homeDirectory = "/home/${details.username}";

        sessionVariables = rec {
          # XDG Base directories: https://specifications.freedesktop.org/basedir-spec/latest
          XDG_DATA_HOME="$HOME/.local/share";  # User specific data files
          XDG_CONFIG_HOME="$HOME/.config";     # User specific configuration files
          XDG_STATE_HOME="$HOME/.local/state"; # User specific state files
          XDG_CACHE_HOME="$HOME/.cache";       # User specific non-essential data files

          # Bash history options. See bash man page for details
          HISTSIZE=2000;                       # Number of commands saved per session
          HISTFILESIZE=8000;                   # Number of lines stored in the history file
          HISTCONTROL="ignorespace:erasedups"; # ignore commands with leading whitespace; add each line only once, erasing prev occurrences

          # Home directory cleanup
          HISTFILE="${XDG_STATE_HOME}/bash_history"; # Removes .bash_history from ~

          NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npmrc";  # Removes .npmrc from ~
          NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm";          # Removes .npm/ from ~
          BOTO_CONFIG="${XDG_CONFIG_HOME}/botorc";           # Removes .boto from ~
          ANDROID_USER_HOME="${XDG_DATA_HOME}/android";      # Removes .android/ from ~
          MAVEN_OPTS="-Duser.home=${XDG_DATA_HOME}/maven";   # Removes .m2/ from ~
          JAVA_USER_HOME="${XDG_DATA_HOME}/java";            # Removes .java/ from ~
          GOPATH="${XDG_DATA_HOME}/go";                      # Removes go/ from ~
          LESSHISTFILE="${XDG_STATE_HOME}/lesshst";          # Removes .lesshst from ~
          WGETRC="${XDG_DATA_HOME}/wget-hsts";               # Removes .wget-hsts from ~
        };
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "25.05";
      };
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

  networking = {
    hostName = "laptop"; # Define your hostname.
    networkmanager.enable = true;
    firewall.enable = true;
  };

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
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  # xdg.mime.defaultApplications = {};

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

  users.users.${details.username} = {
    isNormalUser = true;
    description = details.fullName;
    extraGroups = [ "networkmanager" "wheel" "podman" ];
  };

  environment.variables = {
    GTK_USE_PORTAL = 1;
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
    alejandra
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
    kdePackages.spectacle
    kdePackages.xdg-desktop-portal-kde
    #################### Desktop Applications ####################
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
}
