# Mikha's NIXOS Configs
This repository contains my nixos configuration files for my laptop and server.

Several modules (listed below), have their own readme files with more information.
1. [Bash](modules/home-manager/bash/README.md)
1. [Tmux](modules/home-manager/tmux/README.md)
1. [Work](modules/home-manager/work/README.md)



⚠️ This is a work in progress. There are many aspects of my system that are still configured imperatively.

## Useful nix command reference
Update flake inputs (must be run in the same dir as the flake.nix):
```
nix flake update
```
Garbage collect nix store
```
sudo nix store gc
```
Rebuild the system configuration and switch to it (run in the same dir as the flake.nix):
```
sudo nixos-rebuild switch --flake .
```
Check configuration for errors (run in the same dir as the flake.nix):
```
nix flake check .
```

## Resources
- [NixOS & Flakes book](https://nixos-and-flakes.thiscute.world/)
- [Managing dotfiles with home manager](https://wiki.nixos.org/wiki/Home_Manager#Managing_your_dotfiles)
- [Nix Flakes on NixOS](https://nixos.wiki/wiki/flakes#Using_nix_flakes_with_NixOS)
- [Nix concepts](https://zero-to-nix.com/concepts/)