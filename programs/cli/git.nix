{ ... }:
{
  programs.git = {
    enable = true;
    userName = "mikha";
    userEmail = "31388146+MikhaD@users.noreply.github.com";
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