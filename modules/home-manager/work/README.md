# Work Module
This module provides the applications and scripts I use for work.

## Applications
- `cloud-tasks-emulator` (a custom module built from source because it is not in nixpkgs)
- `dsadmin` (a custom module downloaded from github)
- `gcloud` (with the datastore emulator)
- `ngrok`
- `pycharm-professional`
- `intellij-idea-ultimate`
- `java` (open JDK)
- `pgloader`
- `google-cloud-sql-proxy`

## Features

### Emulators Script
There is a script called `emulators` that starts or attaches to tmux session and creates windows for different emulators like PostgreSQL and Redis. It has three modes, `default`, `postgres`, and `testing`. follow up the emulators command with one of these arguments to choose the mode:
- `default`: If you don't specify an argument it opens the default emulators: redis, google datastore, vite and google cloud tasks emulator.
- `postgres`: Opens all the default emulators plus postgres.
- `testing`: Only opens datastore in `--no-store-on-disk` mode.

The postgres and redis emulators are run in podman containers, and the script ensures that the containers are created if they don't exist, started if they are stopped, and logs are followed in the respective tmux windows. Closing their tmux windows will stop the containers.

The script tries to be as flexible as possible with tmux sessions.
- If there is no tmux session called emulators, it creates one.
- If there is a tmux session called emulators, it attaches to it.
- If we are in a tmux session already, it checks if there is another session called emulators
	- if there is, it asks if you want to attach to it
		- if you say no, it asks if you want to add the emulator windows to the current session
	- if there isn't, it asks if you want to add the emulator windows to the current session, or create a new session called emulators.

### dsadmin
A simple admin interface for the google datastore emulator. In order to use it you first need to add google cloud datastore's env variables to your shell.
```bash
eval $(gcloud beta emulators datastore env-init)
dsadmin
```

## Resources
- [Bash completions](https://opensource.com/article/18/3/creating-bash-completion-script)