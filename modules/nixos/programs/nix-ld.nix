{...}: {
  # https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/
  programs.nix-ld.enable = true;
  # libraries = with pkgs; [ # Add missing dynamic libraries here, not in environment.systemPackages
  #   stdenv.cc.cc.lib
  # ];
}
