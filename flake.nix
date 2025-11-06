{
  inputs = {
    emulators.url = "path:./pkgs/emulators";
    emulators.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-on-droid.url = "github:/nix-community/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # ulauncher6.url = "github:Ulauncher/Ulauncher/v6.0.0-beta27";
    # ulauncher6.inputs.nixpkgs.follows = "nixpkgs";
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
    myUtils = import ./lib {inherit (inputs.nixpkgs) lib;};
  in {
    nixosConfigurations =
      builtins.readDir ./hosts/nixos
      |> builtins.mapAttrs (
        hostname: _:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {inherit details inputs hostname myUtils;};
            modules = [
              ./modules/base.nix
              (./. + "/hosts/nixos/${hostname}/configuration.nix")
            ];
          }
      );
    nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {system = "aarch64-linux";};
      extraSpecialArgs = {inherit details inputs myUtils;};
      modules = [
        ./hosts/nix-on-droid/phone/configuration.nix
      ];
    };
    # inspired by https://github.com/librephoenix/nixos-config/blob/95e3002ce7e5519f8692d1903b7cff7110d99c00/flake.nix#L146
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = toString ./install.sh;
        meta.description = "Install script to set up a system using this config";
      };
    });
    # tell nix which formatter to use when you run nix fmt <filename/dir>
    formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
  };
}
