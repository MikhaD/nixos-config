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
}
