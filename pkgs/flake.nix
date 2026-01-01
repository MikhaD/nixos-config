{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: let
    versions = {
      e = "1.0.3";
      tat = "1.0.5";
      retcon = "1.0.1";
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
      retcon = pkgs.stdenv.mkDerivation {
        pname = "retcon";
        version = versions.retcon;
        src = ./retcon;
        nativeBuildInputs = [pkgs.makeWrapper];
        buildInputs = [pkgs.fzf];
        installPhase = ''
          runHook preInstall
          install -D retcon.sh $out/bin/retcon
          sed -i '2s/.*/VERSION="${versions.retcon}"/' $out/bin/retcon
          wrapProgram $out/bin/retcon --prefix PATH : "${pkgs.fzf}/bin"
          install -D retcon.completions.sh $out/share/bash-completion/completions/retcon
          runHook postInstall
        '';
        meta = {
          description = "Utility to search and bulk delete commands from your bash history using fzf.";
          homepage = "https://github.com/MikhaD/nixos-config/tree/main/pkgs/retcon/";
          mainProgram = "retcon";
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
        meta = {
          description = "Utility to improve navigation between tmux sessions.";
          homepage = "https://github.com/MikhaD/nixos-config/tree/main/pkgs/tat/";
          mainProgram = "tat";
          platforms = [system];
        };
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
