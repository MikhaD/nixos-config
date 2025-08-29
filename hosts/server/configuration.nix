{ pkgs, details, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

    home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit details; };
    users.${details.username} = {
      imports = [
        ./../../modules/home-manager/bash
        ./../../modules/home-manager/tmux
      ];
      home = {
        username = details.username;
        homeDirectory = "/home/${details.username}";

        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "25.05";
      };
    };
  };
}