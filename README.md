# Mikha's NIXOS Configs
This repository contains my nixos configuration files for my laptop and server.

Several modules (listed below), have their own readme files with more information.
1. [Bash](modules/home-manager/bash/README.md)
1. [KeyD](modules/nixos/services/keyd/README.md)
1. [Nh](modules/home-manager/nh/README.md)
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
```sh
nix flake update
```
Delete all old revisions and garbage collect nix store
```sh
# If your system imports the nh home manager module
gc
# Normal way (keep 5 old generations)
sudo nix-collect-garbage --keep 5
```
Rebuild the system configuration and switch to it (run in the same dir as the flake.nix):
```sh
# If your system imports the nh home manager module
nh os switch
# Normal way
sudo nixos-rebuild switch --flake .
```
Check configuration for errors (run in the same dir as the flake.nix):
```sh
nix flake check .
```
Format all nix files in the repo (run in the same dir as the flake.nix):
```sh
nix fmt .
```
### Repl
Open a nix repl with the flake loaded
```sh
nix repl .#nixosConfigurations.<system name>
```
Evaluate nix file. Note that you will probably want `let pkgs = import <nixpkgs> { }; in` at the start of the file to get access to nixpkgs.
```nix
nix repl --file <filepath>
```
Load nixpkgs in repl
```nix
:l <nixpkgs>
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

### Generate age key from SSH key
prefix with a space to prevent your password from being stored in your shell history
```sh
 nix-shell -p ssh-to-age --run "export SSH_TO_AGE_PASSPHRASE='<SSH Key Password>' && ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
 # Generate public key
 nix-shell -p age --run "age-keygen -y ~/.config/sops/age/keys.txt"
 # Use age key to replace file with encrypted version
 sops --encrypt --age "$(cat ~/.ssh/id_ed25519.pub)" -i <input file>
 # Edit encrypted file
 sops <encrypted file>
 # (if there is a .sops.yaml file configured)
 sops encrypt/decrypt -i <input file>
```

## Resources
- [NixOS & Flakes book](https://nixos-and-flakes.thiscute.world/)
- [Managing dotfiles with home manager](https://wiki.nixos.org/wiki/Home_Manager#Managing_your_dotfiles)
- [Nix Flakes on NixOS](https://nixos.wiki/wiki/flakes#Using_nix_flakes_with_NixOS)
- [Nix concepts](https://zero-to-nix.com/concepts/)
- [Great intro to flakes & their outputs](https://youtu.be/RoMArT8UCKM)
<details>
	<summary>How to use a custom version of the Linux kernel</summary>

**Example:**

```nix
boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_17.override {
	argsOverride = rec {
		version = "6.17.2";
		modDirVersion = version;
		src = pkgs.fetchurl {
			url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
			hash = "sha256-/evLBlBl9cG43Gim+1nNpQzd2/kQPSB8IZbVXqdk9X8=";
		};
	};
});
```

</details>

## TODO
- Tmux nix options to enable or disable attaching / creating specific session when a new shell is opened
- Make custom cd ... functionality work when there are directories after the ... (e.g. `cd .../some/other/dirs`)
- Set up sops for secrets management
- Move SSH to home manager
- Move Firefox profiles to home manager
- Move Obsidian vault to home manager
- Move Firefox search engines to home manager
- Rofi README
- Overhaul work emulators script bash completions
- Add info on [] and [[]] in bash cheat-sheet
- pkgs README with info on how to write derivations
- Phone SSH
- Bash options:
  - Use unused timer.success, timer.failure, timer.warning, gitBranch.statusSummary, directory.abridged
  - Remove functions from bashrc that are not used when sections are toggled off
  - Create directory icons option
  - Update readme with new prompt section & examples