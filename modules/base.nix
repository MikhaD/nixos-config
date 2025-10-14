# Default config applied to all machines, imported in flake
{
  details,
  hostname,
  inputs,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" details.username]; # Allow me to build system config remotely and push it to this machine via SSH
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = details.timeZone;
  i18n.defaultLocale = "en_ZA.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_ZA.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_ZA.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  programs.command-not-found.enable = true;
  networking.networkmanager.enable = true;
  networking.hostName = hostname;

  environment.systemPackages = with pkgs; [
    nixd
  ];

  system.activationScripts.linkConfig.text = ''
    FLAKE_PATH=${details.flakePath}
    if [[ ! -f $FLAKE_PATH ]]; then
      echo -e "\e[31mERROR:\e[0m Flake must be located at $FLAKE_PATH"
      exit 1
    fi
    if find /etc/nixos -maxdepth 1 -type f | grep -qE "\.(nix|lock)"; then
      echo "\e[31mERROR:\e[0m /etc/nixos must not contain any .nix or .lock files. Remove them and try again."
      exit 1
    else
      if [[ -L /etc/nixos/flake.nix ]]; then
        rm /etc/nixos/flake.nix
      fi
      echo "Creating symlink for $FLAKE_PATH in /etc/nixos"
      ln -s $FLAKE_PATH /etc/nixos/flake.nix
    fi
  '';
}
