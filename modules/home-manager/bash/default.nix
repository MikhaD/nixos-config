{
  config,
  lib,
  ...
}: let
  cfg = config.tmux;

  mkEnableOptionTrue = description:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      inherit description;
    };

  hexFromString = str: let
    hexFromSubstring = start: end: str: builtins.substring start end str |> lib.trivial.fromHexString;
    s =
      if builtins.stringLength str > 1 && builtins.substring 0 1 str == "#"
      then (str |> builtins.stringLength |> builtins.substring 1) str
      else str;
    red = hexFromSubstring 0 2 s;
    green = hexFromSubstring 2 2 s;
    blue = hexFromSubstring 4 2 s;
  in "${toString red};${toString green};${toString blue}";
in {
  options.bash = {
    enable = mkEnableOptionTrue "Enable bash as a shell.";
    prompt.nixShellIndicator = mkEnableOptionTrue "Show an indicator in the bash prompt when inside a nix-shell.";
    prompt.sshIndicator = mkEnableOptionTrue "Show an indicator in the bash prompt when connected via SSH.";
    prompt.distroIcon = mkEnableOptionTrue "Show the distro icon in the bash prompt.";
    prompt.user = mkEnableOptionTrue "Show the user in the bash prompt.";
    prompt.host = lib.mkEnableOption "Show the host in the bash prompt.";
    prompt.directory = {
      enable = mkEnableOptionTrue "Show the current directory in the bash prompt.";
      abridged = config.lib.mkOption {
        type = config.lib.types.bool;
        default = true;
        description = ''
          A more concise display of the current directory with the following features:
          Print / or ~ if we are in the root or home directory
          Print the exact path if we are in a subdirectory of root or home
          Print /…/directory if we are in a subdirectory of a subdirectory of root
          Print ~/…/directory if we are in a subdirectory of a subdirectory of home
          Print ~/<icon>/directory if we are in a subdirectory of a subdirectory of home and the home subdirectory has an icon
          Print ~/<icon>/…/directory if we are more than 2 subdirectories deep in home and the home subdirectory has an icon
        '';
      };
      color = config.lib.mkOption {
        type = config.lib.types.str;
        default = "blue";
        description = "Hex color of the directory section in the bash prompt.";
      };
      # configure icons here
    };
    prompt.gitBranch = mkEnableOptionTrue "Show the current git branch and commits ahead/behind in the bash prompt.";
    prompt.gitStatus = mkEnableOptionTrue "Show the current git status (modified/untracked files) in the bash prompt.";
    prompt.timer = mkEnableOptionTrue "Show a timer for how long the last command took to execute, along with its exit status in the bash prompt.";
    prompt.rootIndicator = mkEnableOptionTrue "Show an indicator in the bash prompt when running as root.";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      # Placed in ~/.bashrc
      initExtra = builtins.readFile ./bash.rc;
      historyFile = "${config.xdg.stateHome}/bash_history";
      historyControl = ["ignoreboth" "erasedups"]; # Ignore commands with leading whitespace; add each line only once, erasing prev occurrences
      historySize = 2000; #                          Number of commands saved per session
      historyFileSize = 8000; #                      Number of lines stored in the history file

      shellAliases = {
        cls = "clear"; #                            Clear screen using cls like windows powershell
        grep = "grep --color=auto"; #               Use grep with color by default
        wifi = "nmcli device wifi show-password"; # Print the wifi password & QR code to join
        myip = "echo $(curl -s ifconfig.me)"; #     Get my public IP address (echo needed to avoid newline issues)
      };

      # All options: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
      shellOptions = [
        "histappend" #              Append to the history file, don't overwrite it
        "checkwinsize" #            Check the window size after each command and update LINES and COLUMNS if necessary
        "extglob" #                 Extended pattern matching features
        "globstar" #                Make the pattern "**" match all files in pathname expansion and 0 or more dirs and subdirs.
        "checkjobs" #               List the status of any stopped and running jobs before exiting the shell
        "dirspell" #                Auto-correct directory names
        "cdspell" #                 Auto-correct minor spelling errors in the argument to the cd builtin
        "no_empty_cmd_completion" # Do not perform command completion on an empty command line
        "autocd" #                  Change to a directory just by typing its name
      ];
    };
  };
}
