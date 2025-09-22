{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tasks-emulator = {
      url = "github:aertje/cloud-tasks-emulator/v1.2.0";
      flake = false;
    };
    dsadmin = {
      url = "github:remko/dsadmin/v0.21.0";
      flake = false;
    };
  };

  outputs = inputs: let
    details = {
      username = "mikha";
      fullName = "Mikha Davids";
      email = "31388146+MikhaD@users.noreply.github.com";
      timeZone = "Africa/Johannesburg";
    };
    mkNixOSConfig = hostname: path: {
      name = hostname;
      value = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit details inputs hostname;};
        modules = [
          ./modules/base.nix
          path
        ];
      };
    };
  in {
    nixosConfigurations = builtins.listToAttrs [
      (mkNixOSConfig "laptop" ./hosts/laptop/configuration.nix)
      (mkNixOSConfig "homelab" ./hosts/homelab/configuration.nix)
    ];
  };
}
