# Default module applied to all nixos machines, imported in flake
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
    warnAboutFlakeLocation = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Log warnings on build and boot if the flake is not located at the location specified in details.flakePath, and symlink it to /etc/nixos/flake.nix.";
    };
    languageServer.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the Nix language server (nixd).";
    };
  };
  config = {
    nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
    nix.settings.trusted-users = ["root" details.username]; # Allow me to build system config remotely and push it to this machine via SSH
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    nixpkgs.config.allowUnfree = true;
    programs.command-not-found.enable = true;

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

    environment.systemPackages =
      []
      ++ lib.optional config.base.languageServer.enable pkgs.nixd;

    # ! HAVING THIS ENABLED PREVENTS ALL REVISIONS FROM BOOTING
    system.activationScripts = lib.mkIf config.base.warnAboutFlakeLocation {
      linkConfig.text = ''
        FLAKE_PATH=${details.flakePath}/flake.nix
        if [[ ! -f $FLAKE_PATH ]]; then
          echo -e "\e[33mWARNING:\e[0m Flake should be located at $FLAKE_PATH"
          exit 0
        fi
        if find /etc/nixos -maxdepth 1 -type f | grep -qE "\.(nix|lock)"; then
          echo "\e[33mWARNING:\e[0m /etc/nixos must not contain any .nix or .lock files."
          exit 0
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
