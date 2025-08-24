{ ... }:
{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "mikha";
        email = "31388146+MikhaD@users.noreply.github.com";
      };
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