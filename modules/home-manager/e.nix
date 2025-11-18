{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.e.packages.${pkgs.stdenv.system}.default
  ];
}
