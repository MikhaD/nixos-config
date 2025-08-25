{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
  let
    details = {
      username = "mikha";
      hostname = "nixos";
    };
  in {
    nixosConfigurations.${details.hostname} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit details; };
      modules = [
        # { nix.settings.experimental-features = ["nix-command" "flakes"]; }
        ./configuration.nix
        inputs.home-manager.nixosModules.default {
          # Use the packages from the NixOS system configuration.
          home-manager.useGlobalPkgs = true;
          # By default packages will be installed to $HOME/.nix-profile. This installs them to /etc/profiles instead.
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { inherit details; }; # Pass details to home.nix
          home-manager.users.${details.username} = import ./home.nix;
        }
      ];
    };
  };
}
