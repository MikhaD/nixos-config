{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.myApps.packages.${pkgs.stdenv.system}.e
  ];
}
