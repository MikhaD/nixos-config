{ pkgs, details, ... }:
{
  home.username = details.username;
  home.homeDirectory = "/home/${details.username}";

  programs.home-manager.enable = true;
  programs.chromium.enable = true;

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}