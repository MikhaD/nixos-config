# Mikha's NIXOS Configs
This repository contains my nixos configuration files for my laptop and server.

Several modules (listed below), have their own readme files with more information.
1. [Bash](modules/home-manager/bash/README.md)
1. [KeyD](modules/nixos/services/keyd/README.md)
1. [Tmux](modules/home-manager/tmux/README.md)
1. [Work](modules/home-manager/work/README.md)
1. [Ulauncher](modules/home-manager/ulauncher/README.md)

> [!Warning]
> This config is a work in progress. There are many aspects of my system that are still configured imperatively, or omitted until I get nix-sops working.

## Useful nix command reference
Update flake inputs (must be run in the same dir as the flake.nix):
```
nix flake update
```
Delete all old revisions and garbage collect nix store
```
sudo nix-collect-garbage -d
```
Rebuild the system configuration and switch to it (run in the same dir as the flake.nix):
```
sudo nixos-rebuild switch --flake .
```
Check configuration for errors (run in the same dir as the flake.nix):
```
nix flake check .
```
Format all nix files in the repo (run in the same dir as the flake.nix):
```
nix fmt .
```

## Resources
- [NixOS & Flakes book](https://nixos-and-flakes.thiscute.world/)
- [Managing dotfiles with home manager](https://wiki.nixos.org/wiki/Home_Manager#Managing_your_dotfiles)
- [Nix Flakes on NixOS](https://nixos.wiki/wiki/flakes#Using_nix_flakes_with_NixOS)
- [Nix concepts](https://zero-to-nix.com/concepts/)
- [Great intro to flakes & their outputs](https://youtu.be/RoMArT8UCKM)

## TODO
- Tmux nix option for highlight color
- Tmux nix options to enable or disable attaching / creating specific session when a new shell is opened
- Make custom cd ... functionality work when there are directories after the ... (e.g. `cd .../some/other/dirs`)
- Set up sops for secrets management
- Move SSH to home manager
- Move Firefox profiles to home manager
- Move Obsidian vault to home manager
- Move Firefox search engines to home manager
- Rofi README
- Overhaul work emulators script
- Overhaul work emulators script bash completions
- Add info on [] and [[]] in bash cheat-sheet
- pkgs README with info on how to write derivations
- Figure out how to get nixpkgs in repl so I can test more easily