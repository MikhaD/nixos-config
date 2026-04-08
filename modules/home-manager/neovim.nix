{...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
  };
}
