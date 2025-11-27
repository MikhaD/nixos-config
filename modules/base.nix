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
  };
}
