{
  config,
  lib,
  ...
}: let
  cfg = config.bash;

  hexFromString = str: let
    hexFromSubstring = start: end: str: lib.substring start end str |> lib.trivial.fromHexString;
    s =
      if lib.stringLength str > 1 && lib.substring 0 1 str == "#"
      then (lib.stringLength str |> lib.substring 1) str
      else str;
    red = hexFromSubstring 0 2 s;
    green = hexFromSubstring 2 2 s;
    blue = hexFromSubstring 4 2 s;
  in "${toString red};${toString green};${toString blue}";

  mkEnableOptionTrue = description:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      inherit description;
    };

  mkColorOption = default: description:
    lib.mkOption {
      type = lib.types.str;
      inherit default description;
      apply = hexFromString;
    };

  mkPrecedenceOption = precedence:
    lib.mkOption {
      type = lib.types.int;
      default = precedence;
      description = "Order of this section in the prompt. Lower numbers appear first. The numbers do not need to be sequential.";
    };

  mkCommandOption = command:
    lib.mkOption {
      type = lib.types.str;
      default = command;
      description = "Internal command used in the bash prompt.";
      visible = false;
      internal = true;
    };
in {
  options.bash = {
    enable = mkEnableOptionTrue "Enable bash as a shell.";
    cursor = {
      shape = lib.mkOption {
        type = lib.types.enum ["block" "underline" "bar"];
        default = "bar";
        description = "Shape of the bash cursor.";
      };
      blink = mkEnableOptionTrue "Make the bash cursor blink.";
    };
    prompt = {
      indicator = {
        ssh = {
          enable = mkEnableOptionTrue "Show an indicator in the bash prompt when connected via SSH.";
          color = mkColorOption "#3DAEE9" "Hex color of the SSH indicator in the bash prompt.";
        };
        nixShell = {
          enable = mkEnableOptionTrue "Show a   before the bash prompt when inside a nix-shell.";
          color = mkColorOption "#7EB7E2" "Hex color of the nix-shell indicator in the bash prompt.";
          pureColor = mkColorOption "#9FE27E" "Hex color of the 󰌪 next to the nix shell icon indicating that it is a pure shell.";
        };
      };
      section = {
        system = {
          enable = mkEnableOptionTrue "Show system information in the bash prompt.";
          distroIcon = mkEnableOptionTrue "Show the distro icon in the bash prompt.";
          user = mkEnableOptionTrue "Show the user in the bash prompt.";
          host = lib.mkEnableOption "Show the host in the bash prompt.";
          color = mkColorOption "#7ED9D9" "Hex color of the system section in the bash prompt.";
          background = mkColorOption "#666666" "Hex background color of the system section in the bash prompt.";
          precedence = mkPrecedenceOption 0;
        };
        directory = {
          enable = mkEnableOptionTrue "Show the current directory in the bash prompt.";
          abridged = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              A more concise display of the current directory with the following features:
              - Print / or ~ if we are in the root or home directory
              - Print the exact path if we are in a subdirectory of root or home
              - Print /…/directory if we are in a subdirectory of a subdirectory of root
              - Print ~/…/directory if we are in a subdirectory of a subdirectory of home
              - Print ~/<icon>/directory if we are in a subdirectory of a subdirectory of home and the home subdirectory has an icon
              - Print ~/<icon>/…/directory if we are more than 2 subdirectories deep in home and the home subdirectory has an icon
            '';
          };
          color = mkColorOption "#000000" "Hex color of the directory section in the bash prompt.";
          background = mkColorOption "#FFFFFF" "Hex background color of the directory section in the bash prompt.";
          # configure directory icons here
          # private options:
          command = mkCommandOption ''\$(_parse_directory)'';
          precedence = mkPrecedenceOption 1;
        };
        gitBranch = {
          enable = mkEnableOptionTrue "Show the current git branch and commits ahead/behind in the bash prompt.";
          statusSummary = mkEnableOptionTrue "Show a summary of the current git status (modified/untracked files) next to the branch name in the bash prompt. This is automatically disabled if gitStatus is enabled to avoid redundancy.";
          color = mkColorOption "#000000" "Hex color of the git branch section in the bash prompt.";
          background = mkColorOption "#1497B8" "Hex background color of the git branch section in the bash prompt.";
          # private options:
          command = mkCommandOption ''\$(_parse_git_branch)'';
          precedence = mkPrecedenceOption 2;
        };
        gitStatus = {
          enable = mkEnableOptionTrue "Show the current git status (modified/untracked files) in the bash prompt.";
          color = mkColorOption "#000000" "Hex color of the git status section in the bash prompt.";
          background = mkColorOption "#1481B8" "Hex background color of the git status section in the bash prompt.";
          # private options:
          command = mkCommandOption ''\$(_parse_git_status)'';
          precedence = mkPrecedenceOption 3;
        };
        timer = {
          enable = mkEnableOptionTrue "Show a timer for how long the last command took to execute, along with its exit status in the bash prompt.";
          success = {
            color = mkColorOption "#000000" "Hex color of the timer when the last command succeeded.";
            background = mkColorOption "#14B879" "Hex background color of the timer when the last command succeeded.";
          };
          failure = {
            color = mkColorOption "#FFFFFF" "Hex color of the timer when the last command failed.";
            background = mkColorOption "#CD3131" "Hex background color of the timer when the last command failed.";
          };
          warning = {
            color = mkColorOption "#000000" "Hex color of the timer when the last command took a long time to execute.";
            background = mkColorOption "#CCA633" "Hex background color of the timer when the last action was an interrupt (Ctrl + C).";
          };
          color = lib.mkOption {
            type = lib.types.str;
            description = "Variable that contains the color of the timer based on last command status.";
            default = "\\$\{_EXIT_FG}";
            visible = false;
            internal = true;
          };
          background = lib.mkOption {
            type = lib.types.str;
            description = "Variable that contains the background color of the timer based on last command status.";
            default = "\\$\{_EXIT_BG}";
            visible = false;
            internal = true;
          };
          # private options:
          command = mkCommandOption "\\$\{_DURATION}";
          precedence = mkPrecedenceOption 4;
        };
        privilege = {
          enable = mkEnableOptionTrue "Show # in the bash prompt when running as root, or $ when not root.";
          color = mkColorOption "#FFFFFF" "Hex color of the root indicator in the bash prompt.";
          background = mkColorOption "#666666" "Hex background color of the root indicator in the bash prompt.";
          # private options:
          command = mkCommandOption ''\\$'';
          precedence = mkPrecedenceOption 5;
        };
      };
      icons = {
        start = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Icon to use at the start of the bash prompt.";
        };
        end = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Icon to use at the end of the bash prompt.";
        };
        sep = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Icon to use as a separator between sections in the bash prompt. Some options are '            '";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = let
      tColors = fg: bg: ''\[\e[0;38;2;${fg};48;2;${bg}m\]'';
      start = prevBg: section: ''${tColors prevBg section.background}${cfg.prompt.icons.sep}\[\e[38;2;${section.color}m\]'';
      end = ''\[\e[0m\]'';
    in {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash_history";
      historyControl = ["ignoreboth" "erasedups"]; # Ignore commands with leading whitespace; add each line only once, erasing prev occurrences
      historySize = 2000; #                          Number of commands saved per session
      historyFileSize = 8000; #                      Number of lines stored in the history file

      shellAliases = {
        cls = "clear"; #                            Clear screen using cls like windows powershell
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
      # Placed in ~/.bashrc
      initExtra = let
        cursors = {
          block = 2;
          underline = 4;
          bar = 6;
        };

        cursor =
          cursors.${cfg.cursor.shape}
          - (
            if cfg.cursor.blink
            then 1
            else 0
          );
        tempSections = lib.filterAttrs (_: v: v.enable) cfg.prompt.section;
        # build system prompt section (required values from itself)
        enabledSections = let
          ss = cfg.prompt.section.system;
        in
          tempSections
          // lib.optionalAttrs (tempSections ? system) {
            system =
              tempSections.system
              // {
                command = lib.concatStringsSep "" (
                  [''\[\e[48;2;${ss.background}m\]'']
                  ++ lib.optional ss.distroIcon "$(distro_icon)"
                  ++ [''\[\e[1;38;2;${ss.color}m\]'']
                  ++ lib.optional ss.user ''\u''
                  ++ lib.optional (ss.host && ss.user) ''@''
                  ++ lib.optional ss.host ''\h''
                  ++ [" "]
                );
              };
          };
        sections = lib.mapAttrsToList (_: v: {inherit (v) background color command precedence;}) enabledSections |> lib.sort (a: b: a.precedence < b.precedence);

        # create array of colors for enabled prompt sections (49 resets background, 39 resets foreground, 0 resets all)
        components = lib.concatStringsSep "" (
          [''PS1="'']
          ++ lib.optional cfg.prompt.indicator.ssh.enable "$(ssh_session)"
          ++ lib.optional cfg.prompt.indicator.nixShell.enable "$(nix_shell)"
          ++ ["\"\n"]
          ++ lib.optional (lib.length sections > 0) ''PS1+="\[\e[38;2;${(lib.elemAt sections 0).background}m\]${cfg.prompt.icons.start}"''
          ++ (lib.imap1 (i: s:
            "\nPS1+=\"${s.command}"
            + (
              if i < (lib.length sections)
              then "${start s.background (lib.elemAt sections i)}\""
              else "\""
            ))
          sections)
          ++ ["\n"]
          ++ lib.optional (lib.length sections > 0) ''PS1+="\[\e[38;2;${(lib.last sections).background};49m\]${cfg.prompt.icons.end}\[\e[0m\] "'' # might not be able to easily set end icon different to sep
        );
      in
        lib.concatStringsSep "\n" [
          (lib.readFile ./bash.rc)
          ''
            ${components}

            unset distro_icon ssh_session nix_shell

            #     ▗▄▄▖▗▖ ▗▖▗▄▄▖  ▗▄▄▖ ▗▄▖ ▗▄▄▖
            #    ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌ ▐▌
            #    ▐▌   ▐▌ ▐▌▐▛▀▚▖ ▝▀▚▖▐▌ ▐▌▐▛▀▚▖
            #    ▝▚▄▄▖▝▚▄▞▘▐▌ ▐▌▗▄▄▞▘▝▚▄▞▘▐▌ ▐▌

            echo -ne "\e[?${toString cursor} q"
          ''
        ];
    };
  };
}
