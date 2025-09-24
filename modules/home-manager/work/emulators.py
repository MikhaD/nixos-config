import argparse
import copy
import json
import os
import subprocess
import sys


class Tmux:
    def __init__(self, name: str):
        # check if tmux session exists and create it if it doesn't
        self.name = name
        if not Tmux.session_exists(name):
            subprocess.run(f"tmux new-session -d -s {name}", shell=True)

    def new_window(self, name: str, command: str, dir: str | None = None):
        if not self.has_window(name):
            dir_cmd = f"cd {dir} && " if dir else ""
            subprocess.run(f"tmux new-window -n {name} \"{dir_cmd}{command}\"", shell=True)

    def kill_window(self, name: str):
        if self.has_window(name):
            subprocess.run(f"tmux kill-window -t {name}", shell=True)

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
    def session_name() -> str:
        if Tmux.in_session():
            return subprocess.run("tmux display-message -p '#S'", capture_output=True, shell=True, text=True).stdout.strip()
        return ""


class Emulator:
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

    def start(self, session: Tmux):
        if not session.has_window(self.name):
            session.new_window(self.name, self.command, self.dir)
            print("[32mSTARTED[0m:", self.name)
        else:
            print(f"[33mSKIPPED[0m: {self.name} (already running)")

    def stop(self, session: Tmux):
        session.kill_window(self.name)


def merge(a: dict, b: dict) -> dict:
    result = copy.deepcopy(a)
    for key, value in b.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = merge(result[key], value)
        else:
            result[key] = copy.deepcopy(value)
    return result


def get_config(write_default_if_absent: bool = True) -> dict:
    config = {
        "settings": {
            "target-session": "emulators",
            "container-tool": "podman",
            "add-to-current-session": False
        },
        "emulators": {
            "redis": {
                "container": {
                    "image": "redis:latest",
                    "name": "redis_server",
                    "ports": ["6379:6379"],
                }
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

    if os.getenv("XDG_CONFIG_HOME"):
        config_path = os.path.join(os.getenv("XDG_CONFIG_HOME", "~/.config"), "emulators", "config.json")
    else:
        config_path = "~/.config/emulators/config.json"
    config_path = os.path.expanduser(config_path)

    if os.path.exists(config_path):
        with open(config_path) as f:
            config = merge(config, json.load(f))
    elif write_default_if_absent:
        os.makedirs(os.path.dirname(config_path), exist_ok=True)
        with open(config_path, "w") as f:
            json.dump(config, f, indent=2)
    return config


if __name__ == "__main__":
    config = get_config()

    parser = argparse.ArgumentParser(
        description="Manage local emulators in tmux sessions",
        epilog="Emulators are defined in a config file (default ~/.config/emulators/config.json). You can create it manually or let this script create a default one for you."
    )
    parser.add_argument("--target-session", "-t", type=str, help="Name of the tmux session to add the emulator windows to (default: emulators)", default=None)
    parser.add_argument("--add-to-current-session", "-c", action="store_true", help="Add emulator windows to the current tmux session if one exists (overrides --target-session)")
    parser.add_argument("--container-tool", "-C", type=str, choices=["docker", "podman"], help="Containerization tool to use for container emulators.", default=None)
    sub_parsers = parser.add_subparsers(title="Sub commands", dest="command", required=True)
    start_parser = sub_parsers.add_parser("start", help="Start the specified emulators, or all emulators in the default preset if none are specified.")
    stop_parser = sub_parsers.add_parser("stop", help="Stop the specified emulators, removing their tmux windows and stopping their containers if applicable. If no emulators are specified, all running emulators will be stopped.")
    for p in [start_parser, stop_parser]:
        p.add_argument("emulators", nargs="*", choices=config["emulators"].keys(), help="Emulator names (defaults to preset 'default' if none)")
        p.add_argument("--preset", "-p", choices=config["presets"].keys(), type=str, action="append", help="Preset name(s) to include emulators from", default=[])
    sub_parsers.add_parser("attach", help="Attach to the tmux session with the emulators")
    sub_parsers.add_parser("list", help="List all available emulators")
    preset_parser = sub_parsers.add_parser("preset", help="List presets or show emulators in a preset")
    preset_subparsers = preset_parser.add_subparsers(
        title="Preset sub commands",
        dest="preset_command",
        required=True
    )
    preset_subparsers.add_parser("list", help="List all available presets")
    preset_show_parser = preset_subparsers.add_parser("show", help="Show the emulators in the specified preset")
    preset_show_parser.add_argument("preset_name", type=str, choices=config["presets"].keys(), help="Name of the preset to show")

    args = parser.parse_args()

    if args.container_tool:
        config["settings"]["container-tool"] = args.container_tool

    session_name = args.target_session if args.target_session else config["settings"]["target-session"]
    if (args.add_to_current_session or config["settings"].get("add-to-current-session")) and Tmux.in_session():
        session_name = Tmux.session_name()

    if args.command == "list":
        for name in config["emulators"]:
            print(name)
        exit(0)

    elif args.command == "attach":
        if not Tmux.session_exists(session_name):
            print(f"Session {session_name} does not exist.", file=sys.stderr)
            exit(1)
        session = Tmux(session_name)
        session.attach(1)
        exit(0)

    if args.command == "preset":
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

    emulator_names = set(args.emulators).union(*[config["presets"][preset] for preset in args.preset])
    if not emulator_names and args.command in ["start", "stop"]:
        emulator_names = config["presets"]["default"]

    emulators = [
        Emulator(name, config["emulators"][name], config["settings"]["container-tool"]) for name in emulator_names
    ]

    session = Tmux(session_name)

    for emulator in emulators:
        if args.command == "start":
            emulator.start(session)
        elif args.command == "stop":
            emulator.stop(session)

    if args.command == "start":
        session.attach(1)
