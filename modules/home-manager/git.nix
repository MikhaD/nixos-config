{details, ...}: {
  programs.git = {
    enable = true;
    userName = details.username;
    userEmail = details.email;
    aliases = {
      logg = "log --oneline --graph --all --decorate";
    };
    extraConfig = {
      push.autoSetupRemote = true;
      fetch = {
        prune = true;
        pruneTags = true;
      };
      init.defaultBranch = "main";
      core.autocrlf = "input";
      advice.addIgnoredFile = false;
      color.ui = "auto";
    };
  };
}
