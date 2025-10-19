# Default config applied to all machines, imported in flake
{
  config,
  details,
  hostname,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.base = {
    enforceFlakeLocation = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Prevent building if the flake is not located at the location specified in details.flakePath, and symlink it to /etc/nixos/flake.nix.";
    };
    languageServer.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the Nix language server (nixd).";
    };
    commandNotFound.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable command-not-found suggestions in the terminal.";
    };
  };
  config = {
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

    networking.networkmanager.enable = true;
    networking.hostName = hostname;

    programs.command-not-found.enable = config.base.commandNotFound.enable;

    environment.systemPackages =
      []
      ++ lib.optional config.base.languageServer.enable pkgs.nixd;

    system.activationScripts = lib.mkIf config.base.enforceFlakeLocation {
      linkConfig.text = ''
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
    };
  };
}
