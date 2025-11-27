{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    myApps.url = "path:./pkgs";
    myApps.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-on-droid.url = "github:/nix-community/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";

    # Secrets I don't want in a public repo, but are not secret enough that they must be hidden from the global nix store
    secrets.url = "git+ssh://git@github.com/MikhaD/nix-secrets.git?shallow=1";

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
    myLib = import ./lib {inherit (inputs.nixpkgs) lib;};
  in
    # Generate a nixos system for each host in hosts/nixos
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      flake = {
        nixosConfigurations =
          builtins.readDir ./hosts/nixos
          |> builtins.mapAttrs (
            hostname: _:
              inputs.nixpkgs.lib.nixosSystem {
                specialArgs = {inherit details inputs hostname myLib;};
                modules = [
                  ./modules/base.nix
                  (./. + "/hosts/nixos/${hostname}/configuration.nix")
                ];
              }
          );
        homeConfigurations =
          builtins.readDir ./hosts/nixos
          |> builtins.mapAttrs (
            hostname: _:
              inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
                specialArgs = {inherit details inputs hostname myLib;};
                modules = [
                  (./. + "/hosts/nixos/${hostname}/home.nix")
                ];
              }
          );
        nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import inputs.nixpkgs {system = "aarch64-linux";};
          extraSpecialArgs = {inherit details inputs myLib;};
          modules = [
            ./hosts/nix-on-droid/phone/configuration.nix
          ];
        };
      };
      perSystem = {pkgs, ...}: {
        apps.default = {
          # inspired by https://github.com/librephoenix/nixos-config/blob/95e3002ce7e5519f8692d1903b7cff7110d99c00/flake.nix#L146
          type = "app";
          program = toString ./install.sh;
          meta.description = "Install script to set up a system using this config";
        };
        # tell nix which formatter to use when you run nix fmt <filename/dir>
        formatter = pkgs.alejandra;
      };
    };
}
