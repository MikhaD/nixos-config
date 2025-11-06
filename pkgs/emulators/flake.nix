{
  description = "Python program to start and run emulators in tmux";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05";
    cloud-tasks-emulator = {
      url = "github:aertje/cloud-tasks-emulator/v1.2.0";
      flake = false;
    };
    dsadmin = {
      url = "github:remko/dsadmin/v0.22.0";
      flake = false;
    };
  };
  outputs = inputs: let
    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      # "aarch64-linux"
    ];
    meta = system: {
      description = "Python program to start, run & manage emulators in tmux";
      homepage = "https://github.com/MikhaD/nixos-config/tree/main/modules/home-manager/work/";
      mainProgram = "emulators";
      platforms = [system];
    };
  in {
    packages = forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in {
      cloud-tasks-emulator = pkgs.buildGoModule {
        pname = "cloud-tasks-emulator";

        src = inputs.cloud-tasks-emulator;

        version = inputs.cloud-tasks-emulator.shortRev;

        vendorHash = "sha256-jThPgALga/mhLW5zNKEj8vcge7HbbFGZHTRTc2ALIP0=";
        subPackages = ["."];
        ldflags = ["-s" "-w"];

        meta = {
          description = "Google cloud tasks emulator";
          homepage = "https://github.com/aertje/cloud-tasks-emulator";
          license = pkgs.lib.licenses.mit;
          mainProgram = "cloud-tasks-emulator";
        };
      };
      dsadmin = let
        src = inputs.dsadmin;
        version = src.shortRev;
        # https://nixos.org/manual/nixpkgs/stable/#javascript-yarn2nix-mkYarnPackage
        frontend = pkgs.mkYarnPackage {
          pname = "dsadmin-frontend";
          inherit version src;
          packageJSON = "${src}/package.json";
          yarnLock = "${src}/yarn.lock";

          nativeBuildInputs = [pkgs.nodejs];

          buildPhase = ''
            cp -r $src/* .
            chmod +w public
            ${pkgs.nodejs}/bin/node build.mjs
          '';

          installPhase = ''
            mkdir -p $out
            cp -r public/* $out/
          '';

          doDist = false;
        };
      in
        pkgs.buildGoModule {
          pname = "dsadmin";
          inherit version src;

          vendorHash = null;
          subPackages = ["cmd/dsadmin"];
          ldflags = ["-s" "-w"];

          preBuild = ''
            cp -r ${frontend}/* public/
          '';
          meta = {
            description = " Google Cloud Datastore Emulator Administration UI";
            homepage = "https://github.com/remko/dsadmin";
            license = pkgs.lib.licenses.mit;
            mainProgram = "dsadmin";
          };
        };
      # https://nixos.org/manual/nixpkgs/unstable/#buildpythonapplication-function
      default = pkgs.python3Packages.buildPythonApplication {
        pname = "emulators";
        version = "1.1.1";
        src = ./.;
        format = "other";
        propagatedBuildInputs = [
          inputs.self.packages.${system}.cloud-tasks-emulator
          inputs.self.packages.${system}.dsadmin
          pkgs.jdk
          (pkgs.google-cloud-sdk.withExtraComponents
            (with pkgs.google-cloud-sdk.components; [
              cloud-datastore-emulator
            ]))
          pkgs.redis
          pkgs.nodejs
          pkgs.podman
          pkgs.tmux
        ];
        installPhase = ''
          runHook preInstall
          install -D emulators.py $out/bin/emulators
          install -D emulators-completions.sh $out/share/bash-completion/completions/emulators
          runHook postInstall
        '';
        meta = meta system;
      };
    });
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${inputs.self.packages.${system}.default}/bin/emulators";
        meta = meta system;
      };
    });
  };
}
