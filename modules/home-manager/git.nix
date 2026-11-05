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
        log1 = "git log --date=short --pretty=format:'%C(bold blue)%ad%C(reset): %s'";
        sb = "status -sb";
        ss = "status -s";
        checkoutt = "!git checkout $(git branch --format='%(refname:short)' | fzf --reverse)";
        del = "!git branch -D $(git branch --format='%(refname:short)' | fzf --reverse --multi)";
        tagg = "!f() { git tag \"$1\" && git push origin \"$1\"; }; f";
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
