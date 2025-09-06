# Bash
This module configures bash. Importing it into home manager will enable bash with the following options and additional functionality.
> Be aware that a nerd font is required to see all icons in the prompt. JetBrains Mono Nerd Font can be included by importing `modules/nixos/system/fonts.nix` in your system configuration.

## Shell options
- Press Tab to autocomplete file names and commands
- Ignore case when autocompleting
- Use ↑ to search backwards through your history for the text in the prompt
- Use ↓ to search forwards through your history for the text in the prompt

## Extra Functionality
- cd accepts any number of `.`s after `..` to go up additional directories (e.g. `cd ...` goes up 2 directories, `cd ....` goes up 3, etc).

## Prompt Customization
The bash prompt has 6 sections. If a section is not applicable, it is omitted. The sections are as follows:

![prompt sections](../../../.assets/readme-images/bash-prompt-sections.png)

#### 0: Environment
This section shows before the prompt and indicates if you are in a special environment. It can show any combination of the following:
- A blue 󰢹 (remote desktop icon) if you are in an SSH shell.
- A light blue  (nix snowflake) if you are in a nix shell, followed by a green 󰌪 (leaf) if you are in a pure nix shell.

#### 1: OS Distribution and User
This section shows the OS distribution icon and your username. The icon works for debian, nixos, ubuntu and termux (android).

#### 2: Current Directory
This section shows the current directory, which is be abbreviated for long paths.


- The current user's home directory is abbreviated as `~`.
- Directories with specific names in the home directory and the `/` directory are replaced with icons when you are within their sub directories (if you are in a dir with an icon but not in one of it's sub dirs it's name will not be replaced by an icon). Desktop, Documents, Downloads, Music, Pictures etc. are all examples of directories that have icons. You can find the full list in the `bashrc` file in this module (see `DIR_ICONS`).
- If more than 1 directory deep in the current users home directory or `/`, the path is abbreviated to show `…/<current-dir>` for brevity. If the root directory in `~` or `/` is a directory with an icon, it will be `<icon>/…/<current-dir>`, and will only truncate when you are more than 2 directories deep.<br>
	![prompt sections](../../../.assets/readme-images/bash-prompt-dir.png)<br>
	In the example above the user is several directories deep in the Documents dir in their home directory, in a dir called Personal.

#### 3: Git Status
This section shows the current git branch and status if you are in a git repository.
- If you are in a new repo with no commits, it will show  (new shoot icon). You can see an example of this in the first image of the [Prompt Customization](#prompt-customization) section.
- If you are on a branch, it will show the branch name.
- If you are in a detached head state, it will show ⚠️ followed by the short commit hash.
- If there are commits that have not been pushed to the remote, it will show ↑, followed by the number of commits.
- If there are commits that have not been pulled from the remote, it will show ↓, followed by the number of commits.

#### 4: Command Duration & Exit Status
This section shows the duration of the last command down to the millisecond. The units go up to days. The color of this section changes based on the exit status of the previous command:
- green for 0 (success)
- yellow for 127 (command not found)
- red for everything else.

#### 5: Prompt Symbol
This section shows a `$` for normal users and a `#` for root.

## Aliases
The following aliases are included by default:
| Alias | Command | Description |
|-------|---------|-------------|
| `cls` | `clear` | Clear the terminal |
| `reload` | `source ~/.bashrc` | Reload the bash configuration |
| `grep` | `grep --color=auto` | Enable colored grep output |
| `..` | `cd ..` | Go up one directory |
| `wifi` | `nmcli device wifi show-password` | Print the current wifi SSID, password and a QR code to join it |

## Extra Resources
- [Color codes & how to use them](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)