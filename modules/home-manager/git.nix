{details, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = details.username;
        email = details.email;
        signingkey = "$HOME/.ssh/id_ed25519.pub";
      };
      aliases.logg = "log --oneline --graph --all --decorate";
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
      advice.addIgnoredFile = false;
      color.ui = "auto";
      gpg.format = "ssh";
    };
  };
}
