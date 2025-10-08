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

## dsadmin
A simple admin interface for the google datastore emulator. In order to use it you first need to add google cloud datastore's env variables to your shell.
```bash
eval $(gcloud beta emulators datastore env-init)
dsadmin
```

## Emulators Script
There is a script called `emulators` which can be used to start or stop individual emulators (like postgreSQL and redis), or groups of emulators using presets (like `default` and `testing`) in windows in a tmux session (called emulators by default).

The script tries to be as flexible as possible with tmux sessions.
- If there is no tmux session called emulators, it creates one.
- If there is a tmux session called emulators, it attaches to it.
- If we are in a tmux session already, it checks if there is another session called emulators
	- if there is, it asks if you want to attach to it
		- if you say no, it asks if you want to add the emulator windows to the current session
	- if there isn't, it asks if you want to add the emulator windows to the current session, or create a new session called emulators.

Below is a list of available sub commands and flags:

### Flags
| Option | Description |
|--------|-------------|
| `--help`, `-h` | Show help message for application and exit. |
| `--add-to-current-session`, `-a` | Add emulator windows to the current tmux session if one exists (overrides --target-session). |
| `--container-tool`, `-c` `{docker,podman}` | Containerization tool to use for container emulators. |
| `--quiet`, `-q` | Suppress non-error output for commands that do not explicitly print output. |
| `--target-session`, `-t` `<session-name>` | Name of the tmux session to add the windows to (default: emulators). |

### Sub Commands
#### `start`
Start the specified emulators or preset. If no emulators or preset is specified, starts the `default` preset. Emulators specified more than once are only started once.

##### Flags
| Option | Description |
|--------|-------------|
| `--help`, `-h` | Show help message `start` sub command and exit. |
| `--preset`, `-p` `<preset-name>` | Start the given preset. Can be specified multiple times to combine presets. |
| `--exclude`, `-x` `<emulator-name>` | Do not start the given emulator. Can be specified multiple times. Useful if you want most of the emulators in a preset. |

##### Arguments
| Argument | Description |
|----------|-------------|
| `emulator(s)` | A space separated list of emulators to start. |

##### Examples
```bash
# Start all emulators in the dsadmin and postgres presets
emulators start -p dsadmin -p postgres
# Start the vite and redis emulators
emulators start vite redis
# Start all emulators in the default preset except for redis and datastore
emulators start -x redis -x datastore
```

#### `stop`
Stop the specified emulators or preset. If no emulators or preset is specified, stops all running emulators. Emulators specified more than once are only stopped once. Emulators that are not running are ignored.

##### Flags
| Option | Description |
|--------|-------------|
| `--help`, `-h` | Show help message `stop` sub command and exit. |
| `--preset`, `-p` `<preset-name>` | Stop the given preset. Can be specified multiple times to combine presets. |
| `--exclude`, `-x` `<emulator-name>` | Do not stop the given emulator. Can be specified multiple times. Useful if you want to stop most of the emulators in a preset. |

##### Arguments
| Argument | Description |
|----------|-------------|
| `emulator(s)` | A space separated list of emulators to stop. |

##### Examples
```bash
# Stop all emulators in the postgres preset except for vite
emulators stop -p postgres -x vite
# Stop the redis and vite emulators
emulators stop redis vite
# Stop all running emulators
emulators stop
```

#### `attach`
Attach to the tmux session where the emulators are running. Throws an error if there is no session.

#### `list`
List all available emulators.

#### `preset`
List all available presets or show the emulators in a preset.

##### Sub Commands
| Sub Command | Description |
|-------------|-------------|
| `list` | List all available presets. |
| `show` `<preset-name>` | Show the emulators in the given preset. |

##### Examples
```bash
# List all available presets
emulators preset list
# Show the emulators in the default preset
emulators preset show default
```

#### `config`
Manage the configuration file.

##### Sub Commands
| Sub Command | Description |
|-------------|-------------|
| `edit` | Open the configuration file in the editor specified by `$EDITOR` (or `nano` if not set). |
| `init` [`-f`] | Create a default configuration file at `~/.config/emulators/config.json` if one does not already exist. Use `-f` to overwrite the existing config if there is one. |
| `show` | Show the current configuration file, along with its location (location not shown if output is piped or --quiet is true). |

##### Examples
```bash
# Create a default config file
emulators config init
# Create a default config file, overwriting the existing one if it exists
emulators config init -f
# Edit the config file
emulators config edit
# Show the config file
emulators config show
```

### Configuration
This script can be configured extensively, allowing you to add your own emulators, change how existing emulators are run, create your own presets, and change various other settings. The configuration file is a JSON file located at `~/.config/emulators/config.json`. If the file does not exist, you can create a default one using the command `emulators config init`.

#### Emulators
Emulators are specified under `emulators.<name>`. There are two types of emulators: process emulators and container emulators. Process emulators are run as processes on the host machine, while container emulators are run in containers using either docker or podman.

All emulators have the following optional properties:
- `dir`: The directory to run the emulator in. If not specified, the current working directory is used.

##### Process Emulators
Process emulators have the following additional properties:
| Property | Required | Description |
|----------|----------|-------------|
| `commands` | true | A list of commands to run the emulator. This is an array of strings. |

##### Container Emulators
Container emulators are identified by the "container" property, which has the following options. If any process emulator properties are specified alongside "container" they are ignored:
| Property | Required | Description |
|----------|----------|-------------|
| `container.image` | true | The docker/podman image to use for the container. |
| `container.name` | true | The name to give the container. |
| `container.ports` | false | A list of ports to map from the host to the container. Each port mapping should be in the format "host_port:container_port". |
| `container.environment` | false | A dictionary of environment variables and their values to set in the container. |

Container emulators first check if the container exists. If it does not, it is created using the specified image, name, ports, and environment variables. If it does exist but is stopped, it is started with the `-a` flag in a tmux window. If it is already running, its logs are tailed in a tmux window.
When the tmux window is closed, the container is stopped, regardless of whether it was started by the script.

#### Presets
Presets are groups of emulators that can be started or stopped together. Presets can contain any number of emulators, and emulators can be in multiple presets. Presets are specified under `presets.<name>` as lists of emulator names.

#### Settings
Various settings for the script can be configured under the `settings` property. Each flag on the base script can also be specified as a setting (without the -- prefix), telling the script to always use that flag unless overridden on the command line.

### Completions
There is a bash completion script included with the emulators script, allowing you to tab complete emulators, presets, and sub commands. It uses the emulators script itself to get the list of emulators and presets, so it will complete any custom emulators or presets you have added to the config file.

## Resources
- [Bash completions](https://opensource.com/article/18/3/creating-bash-completion-script)