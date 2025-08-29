{...}: {
  programs.bat = {
    enable = true;
    config = {
      # Each settings is equivalent to one of bat's cli flags. See `bat --help` for all options
      theme = "Visual Studio Dark+";
      tabs = "2";
    };
  };
}
