{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: let
    version = "1.0.0";
    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      # "aarch64-linux"
    ];
    meta = system: {
      description = "Program to print the value of the specified environment variable";
      homepage = "https://github.com/MikhaD/nixos-config/tree/main/pkgs/e/";
      mainProgram = "e";
      platforms = [system];
    };
  in {
    packages = forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in {
      default = pkgs.stdenv.mkDerivation {
        pname = "e";
        inherit version;
        src = ./.;
        installPhase = ''
          runHook preInstall
          install -D e.sh $out/bin/e
          sed -i '2s/.*/VERSION="${version}"/' $out/bin/e
          install -D e.completions.sh $out/share/bash-completion/completions/e
          runHook postInstall
        '';
        meta = meta system;
      };
    });
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${inputs.self.packages.${system}.default}/bin/e";
        meta = meta system;
      };
    });
  };
}
