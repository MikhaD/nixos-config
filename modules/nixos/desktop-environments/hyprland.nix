# remove stdenv.cc.cc.lib and LD_LIBRARY_PATH from home-manager/work/default.nix
{...}: {
  programs.hyprland = {
    enable = true;
  };
}
