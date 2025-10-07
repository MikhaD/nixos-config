{...}: {
  programs.jq = {
    enable = true;
    colors = {
      null = "0;34";
      false = "0;34";
      true = "0;34";
      numbers = "0;36";
      strings = "1;33";
      arrays = "1;35";
      objects = "1;37";
      objectKeys = "0;33";
    };
  };
}
