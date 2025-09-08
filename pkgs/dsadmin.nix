{ lib, stdenv, fetchurl }:
stdenv.mkDerivation {
  pname = "dsadmin";
  version = "0.21.0";

  src = fetchurl {
    url = "https://github.com/remko/dsadmin/releases/download/v0.21.0/dsadmin-v0.21.0-linux-amd64.tar.gz";
    sha256 = "sha256-K5eW3/K+jbxzVACj83AlpXDUqToN3VhdjsCrQU4t34M=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true; # Need to skip auto unzip and do it manually during the install phase because there is no folder in the tarball, it just contains the binary.

  installPhase = ''
    runHook preInstall
    tar -xzf $src
    install -Dm755 dsadmin "$out/bin/dsadmin"
    runHook postInstall
  '';

  meta = with lib; {
    description = " Google Cloud Datastore Emulator Administration UI ";
    homepage = "https://github.com/remko/dsadmin";
    license = licenses.mit;
    mainProgram = "dsadmin";
  };
}