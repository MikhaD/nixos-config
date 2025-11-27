{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: let
    versions = {
      e = "1.0.2";
      tat = "1.0.2";
    };
    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
  in {
    packages = forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in {
      e = pkgs.stdenv.mkDerivation {
        pname = "e";
        version = versions.e;
        src = ./e;
        installPhase = ''
          runHook preInstall
          install -D e.sh $out/bin/e
          sed -i '2s/.*/VERSION="${versions.e}"/' $out/bin/e
          install -D e.completions.sh $out/share/bash-completion/completions/e
          runHook postInstall
        '';
        meta = {
          description = "Utility to print the value of the specified environment variable (with case insensitive bash completions).";
          homepage = "https://github.com/MikhaD/nixos-config/tree/main/pkgs/e/";
          mainProgram = "e";
          platforms = [system];
        };
      };
      tat = pkgs.stdenv.mkDerivation {
        pname = "tat";
        version = versions.tat;
        src = ./tat;
        nativeBuildInputs = [pkgs.makeWrapper];
        buildInputs = [pkgs.fzf];
        installPhase = ''
          runHook preInstall
          install -D tat.sh $out/bin/tat
          sed -i '2s/.*/VERSION="${versions.tat}"/' $out/bin/tat
          wrapProgram $out/bin/tat --prefix PATH : "${pkgs.fzf}/bin"
          install -D tat.completions.sh $out/share/bash-completion/completions/tat
          runHook postInstall
        '';
      };
    });
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${inputs.self.packages.${system}.default}/bin/e";
        meta = {
          description = "Utility to print the value of the specified environment variable (with case insensitive bash completions).";
          homepage = "https://github.com/MikhaD/nixos-config/tree/main/pkgs/e/";
          mainProgram = "e";
          platforms = [system];
        };
      };
    });
  };
}
