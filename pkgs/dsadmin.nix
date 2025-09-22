{
  buildGoModule,
  mkYarnPackage,
  nodejs,
  src,
}: let

  inherit src;

  version = src.shortRev;

  # https://nixos.org/manual/nixpkgs/stable/#javascript-yarn2nix-mkYarnPackage
  frontend = mkYarnPackage {
    pname = "dsadmin-frontend";
    inherit version src;
    packageJSON = "${src}/package.json";
    yarnLock = "${src}/yarn.lock";

    nativeBuildInputs = [nodejs];

    buildPhase = ''
      cp -r $src/* .
      chmod +w public
      ${nodejs}/bin/node build.mjs
    '';

    installPhase = ''
      mkdir -p $out
      cp -r public/* $out/
    '';

    doDist = false;
  };
in
  buildGoModule {
    pname = "dsadmin";
    inherit version src;

    vendorHash = null;
    subPackages = ["cmd/dsadmin"];
    ldflags = ["-s" "-w"];

    preBuild = ''
      cp -r ${frontend}/* public/
    '';
  }
