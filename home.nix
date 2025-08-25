{ pkgs, details, ... }:
{
  imports = [
      ./programs/cli/bash.nix
      ./programs/cli/bat.nix
      ./programs/cli/git.nix
      ./programs/cli/neovim.nix
      ./programs/cli/python.nix
      # ./programs/cli/ssh.nix
      ./programs/cli/wl-clipboard.nix

      ./programs/gui/firefox.nix

      ./programs/work.nix
  ];
  home.username = details.username;
  home.homeDirectory = "/home/${details.username}";

  programs.home-manager.enable = true;
  programs.chromium.enable = true;

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}