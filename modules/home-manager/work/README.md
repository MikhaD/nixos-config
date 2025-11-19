# Work Module
This module provides the applications and scripts I use for work.

## Applications
- [`emulators`](#emulators)
	- [`cloud-tasks-emulator`](#cloud-tasks-emulator)
	- [`dsadmin`](#dsadmin)
	- `gcloud` (with the datastore emulator)
	- `java` (open JDK)
- `pycharm-professional`
<!-- - `intellij-idea-ultimate` -->

### `emulators`
`emulators` is an application used to start or stop individual emulators (like postgreSQL and redis), or groups of emulators using presets (like `default` and `testing`) in windows in a tmux session (called emulators by default).
This app also provides several dependencies required to start the base emulators.

See the [readme](https://github.com/MikhaD/nix-config/tree/main/pkgs/emulators) for more information.

### `cloud-tasks-emulator`
A third party Google Cloud Tasks emulator because Google does not provide an official one. Built from source.

### `dsadmin`
A third party admin interface for the Google Datastore Emulator, built from source. In order to use it you first need to add google cloud datastore's env variables to your shell.
```bash
eval $(gcloud beta emulators datastore env-init)
dsadmin
```