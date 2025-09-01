{
  details,
  hostname,
  ...
}: {
  # Default config applied to all machines
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = details.timeZone;
  i18n.defaultLocale = details.locale;
  programs.command-not-found.enable = true;
  networking.networkmanager.enable = true;
  networking.hostName = hostname;
}
