{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:/nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
    ulauncher6 = {
      url = "github:Ulauncher/Ulauncher/v6.0.0-beta27";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    details = rec {
      username = "mikha";
      fullName = "Mikha Davids";
      email = "31388146+MikhaD@users.noreply.github.com";
      timeZone = "Africa/Johannesburg";
      flakePath = "/home/${username}/nix";
    };
    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      # Add more system architectures here as needed
      "x86_64-linux"
      "aarch64-linux"
    ];
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
    nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {system = "aarch64-linux";};
      extraSpecialArgs = {inherit details inputs;};
      modules = [
        ./hosts/phone/configuration.nix
      ];
    };
    utils = forAllSystems (system: import ./lib/default.nix {inherit (inputs.nixpkgs.legacyPackages.${system}) lib;});
    # tell nix which formatter to use when you run nix fmt <filename/dir>
    formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
  };
}
