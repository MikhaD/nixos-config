{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {

    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      # specialArguments = { inherit inputs; };
      modules = [
        { nix.settings.experimental-features = ["nix-command" "flakes"]; }
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
