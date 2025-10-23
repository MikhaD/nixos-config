{details, ...}: {
  # nh os switch
  programs.nh = {
    enable = true;
    flake = details.flakePath;
  };

  programs.bash.shellAliases = {
    gc = "nh clean all --ask --keep 5 --optimise";
  };
}
