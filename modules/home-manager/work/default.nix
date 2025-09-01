{
  pkgs,
  config,
  ...
}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    cloud-datastore-emulator
  ]);
in {
  imports = [
    ./../terraform.nix
  ];

  home.sessionVariables = {
    MAVEN_OPTS = "-Duser.home=${config.xdg.dataHome}/maven"; # Removes .m2/ from ~
    JAVA_USER_HOME = "${config.xdg.dataHome}/java"; # Removes .java/ from ~
    JAVA_USER_PREFS_ROOT = "${config.xdg.configHome}/java"; # Removes .java/ from ~
    PSQL_HISTORY = "${config.xdg.dataHome}/psql_history"; # Removes .psql_history from ~
    GOPATH = "${config.xdg.dataHome}/go"; # Removes go/ from ~
    # TODO: Bad practice, Should be in a nix-env for the thing that needs it (here at the moment to get nix shell created poetry installs to work in pycharm)
    # https://discourse.nixos.org/t/what-package-provides-libstdc-so-6/18707/2
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  home.packages = with pkgs; [
    bruno
    gdk
    google-cloud-sql-proxy
    jdk
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    ngrok
    pgloader
    poetry
    stdenv.cc.cc.lib
    (pkgs.writeShellScriptBin "emulators" (builtins.readFile ./emulators.sh))
  ];
}
