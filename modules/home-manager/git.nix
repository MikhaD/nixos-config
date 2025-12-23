{
  details,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = details.username;
        email = details.email;
      };
      alias = {
        logg = "log --oneline --graph --all --decorate";
        sb = "status -sb";
        ss = "status -s";
      };
      push.autoSetupRemote = true;
      fetch = {
        prune = true;
        pruneTags = true;
      };
      # Enforce SSH for GitHub
      url = {
        "git@github.com:".insteadOf = "https://github.com/";
      };
      pager.branch = false;
      init.defaultBranch = "main";
      core.autocrlf = "input";
      color.ui = "auto";
      tag.gpgSign = false;
      advice = {
        addIgnoredFile = false;
        detachedHead = false;
      };
    };
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  };
}
