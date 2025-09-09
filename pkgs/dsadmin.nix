{
  fetchFromGitHub,
  buildGoModule,
  mkYarnPackage,
  nodejs,
}: let
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "remko";
    repo = "dsadmin";
    rev = "v${version}";
    hash = "sha256-bCqhClBjaDW5Kfoauv4VwW5IczJ3wE85uwsQ+BMUnms=";
  };

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

    distPhase = "true"; # Skip this phase by setting it to a no-op
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
