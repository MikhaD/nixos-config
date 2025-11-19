## Tmux Attach (tat)
This module includes an app called Tmux ATtach (tat) that improves navigation between tmux sessions.
- Use without arguments to enter tmux session selection menu if in tmux and there are multiple sessions.
	- If not in tmux and there are multiple sessions present a fzf menu to select a session to attach to.
	- If not in tmux and there is only one session attach to that session.
	- If in tmux and there is only one session do nothing.

### Options
| Flag            | Description                                                                                               |
|-----------------|-----------------------------------------------------------------------------------------------------------|
| `-h` , `--help` | Show help message and exit.                                                                               |
| `-n` , `--new`  | Create a tmux session with the given session name if no session exists, else attach to the given session. |