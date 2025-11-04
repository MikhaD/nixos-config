#!/usr/bin/env python3
VERSION = "1.1.0"

import argparse
import copy
import json
import os
import subprocess
import sys


class Logger:
    def __init__(self, quiet: bool = False):
        self.quiet = quiet

    def log(self, *args, prefix: str | None = None):
        if not self.quiet:
            if prefix:
                print(f"[32m{prefix}[0m", end="")
            print(*args)

    def warn(self, *args, prefix: str | None = None):
        if not self.quiet:
            if prefix:
                print(f"[33m{prefix}[0m", end="")
            print(*args)

    def danger(self, *args, prefix: str | None = None):
        if not self.quiet:
            if prefix:
                print(f"[31m{prefix}[0m", end="")
            print(*args)

    def error(self, *args, prefix: str | None = None):
        if prefix:
            print(f"[31m{prefix}[0m", end="", file=sys.stderr)
        print(*args, file=sys.stderr)


class Tmux:
    def __init__(self, name: str):
        # check if tmux session exists and create it if it doesn't
        self.name = name
        if not Tmux.session_exists(name):
            subprocess.run(f"tmux new-session -d -s {name}", shell=True)

    def new_window(self, name: str, command: str, dir: str | None = None):
        if not self.has_window(name):
            dir_cmd = f"cd {dir} && " if dir else ""
            subprocess.run(f"tmux new-window -d -n {name} \"{dir_cmd}{command}\"", shell=True)

    def kill_window(self, name: str):
        if self.has_window(name):
            # send Ctrl-C to stop the process, otherwise processes like redis-server keep running in the background
            subprocess.run (f"tmux send-keys -t {self.name}:{name} C-c", shell=True)
            subprocess.run(f"tmux kill-window -t {self.name}:{name}", shell=True)
            return True
        return False

    def has_window(self, name: str) -> bool:
        return subprocess.run(f"tmux list-windows -t {self.name} -F '#W' 2>/dev/null | grep -qx '{name}'", shell=True).returncode == 0

    def attach(self, window: int | str | None = None):
        if Tmux.in_session():
            command = f"tmux switch-client -t {self.name}"
        else:
            command = f"tmux attach-session -t {self.name}"
        if window is not None:
            command = f"tmux select-window -t {self.name}:{window} && " + command
        subprocess.run(command, shell=True)

    def kill(self):
        subprocess.run(f"tmux kill-session -t {self.name}", shell=True)

    @staticmethod
    def session_exists(name: str) -> bool:
        result = subprocess.run(f"tmux list-sessions -F '#S' 2>/dev/null | grep -qx '{name}'", shell=True)
        return result.returncode == 0

    @staticmethod
    def in_session() -> bool:
        return bool(os.getenv("TMUX"))

    @staticmethod
    def current_session_name() -> str:
        if Tmux.in_session():
            return subprocess.run("tmux display-message -p '#S'", capture_output=True, shell=True, text=True).stdout.strip()
        return ""


class Emulator:
    logger = Logger()

    def __init__(self, name, config: dict, container_tool: str):
        self.name = name
        if "container" in config:
            container = config["container"]
            name = container["name"]
            # container does not exist
            if subprocess.run(f"{container_tool} ps -a --filter 'name={name}' | grep -q {name}", shell=True).returncode != 0:
                self.command = f"{container_tool} run --name {name} "
                if container.get("ports"):
                    self.command += f"-p {' -p '.join(container['ports'])} "
                if container.get("environment"):
                    for env_key, env_value in container["environment"].items():
                        self.command += f"-e {env_key}='{env_value}' "
                self.command += container['image']
            # container exists but is not running
            elif subprocess.run(f"{container_tool} ps --filter 'name={name}' | grep -q {name}", shell=True).returncode != 0:
                self.command = f"{container_tool} start -a {name}"
            else:
                self.command = f"{container_tool} logs -f {name}"
            self.command = f"trap '{container_tool} stop {name}' EXIT; {self.command}"  # stop container when tmux window is closed
        elif "commands" in config:
            self.command = " && ".join(config["commands"])
        else:
            print(f"Emulator {self.name} is missing both 'container' and 'commands' fields in the config file.", file=sys.stderr)
            exit(1)

        self.dir = config.get("dir")

    def start(self, session: Tmux, logger: Logger | None = None):
        logger = logger or self.logger
        if not session.has_window(self.name):
            session.new_window(self.name, self.command, self.dir)
            logger.log(self.name, prefix="STARTED: ")
        else:
            logger.warn(f"{self.name} (already running)", prefix="SKIPPED: ")

    def stop(self, session: Tmux, logger: Logger | None = None):
        logger = logger or self.logger
        if session.kill_window(self.name):
            logger.danger(self.name, prefix="STOPPED: ")


def merge(a: dict, b: dict) -> dict:
    """
    Recursively merge two dictionaries as a new dictionary. Values from dictionary b take precedence over values from dictionary a.
    """
    result = copy.deepcopy(a)
    for key, value in b.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = merge(result[key], value)
        else:
            result[key] = copy.deepcopy(value)
    return result


def config_path() -> str:
    if os.getenv("XDG_CONFIG_HOME"):
        path = os.path.join(os.getenv("XDG_CONFIG_HOME", "~/.config"), "emulators", "config.json")
    else:
        path = "~/.config/emulators/config.json"
    path = os.path.expanduser(path)
    return path


def get_config(default: bool = False) -> dict:
    """
    Get the configuration for the emulators script. If a config file exists at ~/.config/emulators/config.json, load it and merge it with the default config. Otherwise, return the default config.

    :param default: If True, return the default configuration without loading from file.
    """
    config = {
        "settings": {
            "add-to-current-session": True,
            "container-tool": "podman",
            "quiet": False,
            "target-session": "emulators",
        },
        "emulators": {
            "redis": {
                "dir": "~/Documents/work/quicklysign-python3",
                "commands": ["redis-server"],
            },
            "datastore": {
                "commands": ["gcloud beta emulators datastore start --use-firestore-in-datastore-mode"]
            },
            "ds-ephemeral": {
                "commands": ["gcloud beta emulators datastore start --use-firestore-in-datastore-mode --no-store-on-disk"]
            },
            "vite": {
                "dir": "~/Documents/work/quicklysign-python3/quicklysign/statics",
                "commands": ["npm run dev"],
            },
            "tasks": {
                "commands": ["cloud-tasks-emulator -host localhost -port 8123"]
            },
            "dsadmin": {
                "commands": ["eval $(gcloud beta emulators datastore env-init)", "dsadmin"]
            },
            "postgres": {
                "container": {
                    "image": "postgres:latest",
                    "name": "pg_quicklysign",
                    "ports": ["5432:5432"],
                    "environment": {
                        "POSTGRES_PASSWORD": "testpassword",
                        "POSTGRES_USER": "test",
                        "POSTGRES_DB": "quicklysign"
                    }
                }
            },
        },
        "presets": {
            "default": ["redis", "datastore", "vite", "tasks"],
            "testing": ["redis", "ds-ephemeral"],
            "dsadmin": ["redis", "datastore", "vite", "tasks", "dsadmin"],
            "postgres": ["redis", "datastore", "vite", "tasks", "postgres"]
        }
    }
    if default:
        return config

    path = config_path()

    if os.path.exists(path):
        with open(path) as f:
            config = merge(config, json.load(f))
    return config

def main(version: str):
    config = get_config()
    editor = os.getenv("EDITOR", "nano")

    parser = argparse.ArgumentParser(
        description="Manage local emulators in tmux sessions.",
        epilog="Emulators are defined in a config file (default ~/.config/emulators/config.json). You can create it manually or let this script create a default one for you."
    )
    # Flags
    parser.add_argument("--version", "-v", action="version", version=f"emulators {version}")
    parser.add_argument("--add-to-current-session", "-a", action="store_true", help="Add emulator windows to the current tmux session if one exists (overrides --target-session).")
    parser.add_argument("--container-tool", "-c", type=str, choices=["docker", "podman"], help="Containerization tool to use for container emulators.", default=None)
    parser.add_argument("--quiet", "-q", action="store_true", help="Suppress non-error output for commands that do not explicitly print output.")
    parser.add_argument("--target-session", "-t", type=str, help="Name of the tmux session to add the emulator windows to (default: emulators).", default=None)
    # Sub Commands
    sub_parsers = parser.add_subparsers(title="Sub commands", dest="command", required=True)
    start_parser = sub_parsers.add_parser("start", help="Start the specified emulators, or all emulators in the default preset if none are specified.")
    stop_parser = sub_parsers.add_parser("stop", help="Stop the specified emulators, removing their tmux windows and stopping their containers if applicable. If no emulators are specified, all running emulators will be stopped.")
    for p in [start_parser, stop_parser]:
        p.add_argument("emulators", nargs="*", choices=config["emulators"].keys(), help="Emulator names (defaults to preset 'default' if none).")
        p.add_argument("--preset", "-p", choices=config["presets"].keys(), type=str, action="append", help="Preset name(s) to include emulators from.", default=[])
        p.add_argument("--exclude", "-x", choices=config["emulators"].keys(), type=str, action="append", help="Emulator name(s) to exclude. Useful if you want most of the emulators from a preset.", default=[])

    sub_parsers.add_parser("attach", help="Attach to the tmux session with the emulators.")

    sub_parsers.add_parser("list", help="List all available emulators.")

    preset_parser = sub_parsers.add_parser("preset", help="List all available presets or show emulators in a preset.")
    preset_subparsers = preset_parser.add_subparsers(
        title="Preset sub commands",
        dest="preset_command",
        required=True
    )
    preset_subparsers.add_parser("list", help="List all available presets.")
    preset_show_parser = preset_subparsers.add_parser("show", help="Show the emulators in the specified preset.")
    preset_show_parser.add_argument("preset_name", type=str, choices=config["presets"].keys(), help="Name of the preset to show.")

    config_parser = sub_parsers.add_parser("config", help="Manage the configuration file.")
    config_subparsers = config_parser.add_subparsers(title="Config sub commands", dest="config_command", required=True)
    config_subparsers.add_parser("edit", help=f"Edit the config file in the editor specified by $EDITOR (or nano if not set). Yours is {editor}.")
    init_config_parser = config_subparsers.add_parser("init", help="Create a default config file")
    init_config_parser.add_argument("--force", "-f", action="store_true", help="Overwrite existing config file if it exists.")
    config_subparsers.add_parser("show", help="Show current config contents and path")

    args = parser.parse_args()
    console = Logger(args.quiet or config["settings"].get("quiet", False))

    if args.container_tool:
        config["settings"]["container-tool"] = args.container_tool

    session_name = args.target_session if args.target_session else config["settings"]["target-session"]
    if (args.add_to_current_session or config["settings"].get("add-to-current-session")) and Tmux.in_session():
        session_name = Tmux.current_session_name()

    match args.command:
        case "list":
            for name in config["emulators"]:
                print(name)
            exit(0)

        case "attach":
            if not Tmux.session_exists(session_name):
                console.error(f"Session {session_name} does not exist.", prefix="ERROR: ")
                exit(1)
            session = Tmux(session_name)
            session.attach(1)
            exit(0)

        case "preset":
            if args.preset_command == "list":
                for name in config["presets"]:
                    print(name)
                exit(0)
            elif args.preset_command == "show":
                preset_name = args.preset_name
                if preset_name not in config["presets"]:
                    print(f"Preset {preset_name} not found.", file=sys.stderr)
                    exit(1)
                for name in config["presets"][preset_name]:
                    print(name)
            exit(0)

        case "config":
            path = config_path()
            if args.config_command == "edit":
                subprocess.run(f"{editor} {path}", shell=True)
            elif args.config_command == "init":
                if os.path.exists(path):
                    if args.force:
                        console.warn(f"Config file already exists at{path}. Overwriting.", prefix="WARNING: ")
                    else:
                        console.error(f"Config file already exists at {path}", prefix="ERROR: ")
                        exit(1)
                os.makedirs(os.path.dirname(path), exist_ok=True)
                with open(path, "w") as f:
                    json.dump(get_config(default=True), f, indent=2)
                console.log(f"Created default config file at {path}")
            if args.config_command == "show":
                if sys.stdout.isatty():  # only print location if not being piped
                    if os.path.exists(path):
                        console.log(":", prefix=path)
                    else:
                        console.log(f"[33mNo config file, showing default.\nRun [0m{sys.argv[0]} config init[33m to create one[0m")
                print(json.dumps(get_config(), indent=2))
            exit(0)

        case "start" | "stop":
            emulator_names = set(args.emulators).union(*[config["presets"][preset] for preset in args.preset])
            if not emulator_names:
                if args.command == "start":
                    emulator_names = set(config["presets"]["default"])
                if args.command == "stop":
                    emulator_names = set(config["emulators"].keys())
            emulator_names = emulator_names.difference(set(args.exclude))

            emulators = [
                Emulator(name, config["emulators"][name], config["settings"]["container-tool"]) for name in emulator_names
            ]

            session = Tmux(session_name)

            for emulator in emulators:
                if args.command == "start":
                    emulator.start(session, console)
                elif args.command == "stop":
                    emulator.stop(session, console)

            if args.command == "start" and Tmux.current_session_name() != session.name:
                session.attach(1)

if __name__ == "__main__":
    main(VERSION)
