{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    details = {
      username = "mikha";
      fullName = "Mikha Davids";
      email = "31388146+MikhaD@users.noreply.github.com";
      timeZone = "Africa/Johannesburg";
      locale = "en_ZA.UTF-8";
    };
    mkNixOSConfig = path:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit details inputs;};
        modules = [
          {
            nix.settings.experimental-features = ["nix-command" "flakes"];
            nixpkgs.config.allowUnfree = true;
            time.timeZone = details.timeZone;
            i18n.defaultLocale = details.locale;
          }
          path
        ];
      };
  in {
    nixosConfigurations = {
      laptop = mkNixOSConfig ./hosts/laptop/configuration.nix;
      homelab = mkNixOSConfig ./hosts/homelab/configuration.nix;
    };
  };
}
