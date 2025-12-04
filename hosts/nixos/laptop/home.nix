{
  config,
  details,
  pkgs,
  ...
}: {
  imports = [
    ./../../../modules/home-manager/bash
    ./../../../modules/home-manager/bat.nix
    ./../../../modules/home-manager/chromium.nix
    ./../../../modules/home-manager/curl.nix
    ./../../../modules/home-manager/dig.nix
    ./../../../modules/home-manager/e.nix
    ./../../../modules/home-manager/fastfetch.nix
    ./../../../modules/home-manager/firefox.nix
    ./../../../modules/home-manager/fzf.nix
    ./../../../modules/home-manager/git.nix
    ./../../../modules/home-manager/grep.nix
    ./../../../modules/home-manager/just.nix
    ./../../../modules/home-manager/jq.nix
    ./../../../modules/home-manager/man.nix
    ./../../../modules/home-manager/neovim.nix
    ./../../../modules/home-manager/nh
    ./../../../modules/home-manager/nodejs.nix
    ./../../../modules/home-manager/nom.nix
    ./../../../modules/home-manager/obs.nix
    ./../../../modules/home-manager/obsidian
    ./../../../modules/home-manager/python.nix
    ./../../../modules/home-manager/tree.nix
    ./../../../modules/home-manager/lsd.nix
    ./../../../modules/home-manager/ssh.nix
    ./../../../modules/home-manager/tmux
    # ./../../../modules/home-manager/ulauncher
    ./../../../modules/home-manager/wl-clipboard.nix
    ./../../../modules/home-manager/xdg.nix

    ./../../../modules/home-manager/work
  ];

  home = {
    username = details.username;
    homeDirectory = "/home/${details.username}";
    preferXdgDirectories = true;

    sessionVariables = {
      LESSHISTFILE = "${config.xdg.stateHome}/lesshst"; # Removes .lesshst from ~
      BOTO_CONFIG = "${config.xdg.configHome}/botorc"; # Removes .boto from ~
      # ANDROID_USER_HOME = "${config.xdg.dataHome}/android"; # Removes .android/ from ~
    };

    packages = with pkgs; [
      ########################## CLI Tools #########################
      exfat # Allow me to format drives as exfat (broad OS compatibility)
      figlet
      shfmt
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

    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };
}
