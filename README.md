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

## Opinions
This configuration expects and enforces several rules and patterns:
- This configuration repository must be located at `/home/<username>/nix/flake.nix` (configurable in the flake details).
- The /etc/nixos directory must not contain any .nix or .lock files except for a symlink to the flake.nix file in this repository.
- System modules can install packages in home manager via `home-config.packages`.
- All modules can set options on the user via `default-user.extra`.

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

## SSH Setup
1. This configuration expects you to have SSH keys set up at `~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub`.
These can be generated with:
	```bash
	ssh-keygen -t ed25519 -a 100 -C "<system name>"
	```
	> [!Note]
	> `<system name>` is a unique name for the system (e.g. "laptop" or "homelab"). This is used as a comment in the public key file for easier identification. The -a flag sets the number of KDF (key derivation function) rounds on your ssh key password to 100 for better brute force resistance.

2. Add the public key to github [here](https://github.com/settings/keys) by clicking new SSH key. Add it twice, once as a signing key and once as an authentication key.
3. If you want to use that key to SSH into other systems running SSH servers configured by this repository add the public key to the ./modules/nixos/services/sshd/ssh-public-keys.nix file named `<system name>.pub`.

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