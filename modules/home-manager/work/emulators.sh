#!/bin/bash
# Start all the emulators I need to for work in a tmux session and attach to it, or attach to it if it already exists

# Start the given podman container and show the logs in a tmux window, or open a tmux window on the logs if it is
# already running
# Create the container if it does not exist
# @param $1 - The name of the podman container
# @param $2 - The name of the image to create the container from if it does not exist, and the name of the tmux window
# @param $3 - (Optional) Additional arguments to pass to podman run when creating
start_or_create_container() {
	if ! podman ps -a --filter "name=$1" | grep -q "$1"; then
		podman run --name $1 -d $2 $3
	elif ! podman ps --filter "name=$1" | grep -q "$1"; then
		podman start $1
	fi
}

# @param $1 - The name of the tmux session
# @param $2 - The name of the tmux window
# @param $3 - The command to run in the tmux window
new_window_if_not_exists() {
	if ! tmux list-windows -t "$1" | grep -q "$2"; then
		tmux new-window -t "$1" -n "$2" "$3"
	fi
}

# @param $1 - The argument to pass to this script, either "test" or "postgres"
# @param $2 - The name of the tmux session to add windows to
start_emulators() {
	start_or_create_container "redis_server" "redis:latest" "-p 6379:6379"
	new_window_if_not_exists "$2" "redis" "bash -c '
		trap \"podman stop redis_server\" EXIT
		podman logs -f redis_server
	'" # Run podman stop redis_server when this window is closed
	if [ "$1" == "postgres" ]; then
		start_or_create_container "pg_quicklysign" "postgres:latest" "-p 5432:5432 -e POSTGRES_PASSWORD=testpassword -e POSTGRES_USER=test -e POSTGRES_DB=quicklysign"
		new_window_if_not_exists "$2" "postgres" "bash -c '
			trap \"podman stop pg_quicklysign\" EXIT
			podman logs -f pg_quicklysign
		'" # Run podman stop pg_quicklysign when this window is closed
	fi
	if [ "$1" == "testing" ]; then
		new_window_if_not_exists "$2" "datastore" "gcloud beta emulators datastore start --use-firestore-in-datastore-mode --no-store-on-disk"
	else
		new_window_if_not_exists "$2" "datastore" "gcloud beta emulators datastore start --use-firestore-in-datastore-mode"
		new_window_if_not_exists "$2" "vite" "cd ~/Documents/work/quicklysign-python3/quicklysign/statics && npm run dev"
		new_window_if_not_exists "$2" "tasks" "cloud-tasks-emulator -host localhost -port 8123"
		new_window_if_not_exists "$2" "dsadmin" "eval $(gcloud beta emulators datastore env-init) && dsadmin"
	fi
}

name="emulators"
if [[ $TMUX = "" ]]; then
	# We are not inside a tmux session
	# Does a tmux session called emulators already exist?
	if ! tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -qx $name; then
		tmux new-session -d -s $name
	fi
	start_emulators "$1" "$name"
	tmux attach -t $name:1
else
	session_name=$(tmux display-message -p '#S')
	# We are inside a tmux session
	if [[ $session_name != "emulators" ]]; then
		# check if there is an existing session called emulators
		if tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -qx $name; then
			read -n 1 -t 5 -p "There is an existing tmux session called emulators. Attach to it? (Y/n): "
			echo
			if [[ $REPLY =~ [Yy] || -z $REPLY ]]; then
				start_emulators "$1" "$name"
				tmux switch-client -t $name:1
			else
				read -n 1 -t 5 -p "Add emulator windows to the existing session? (Y/n): "
				echo
				if [[ $REPLY =~ [Yy] || -z $REPLY ]]; then
					start_emulators "$1" "$session_name"
				fi
			fi
		else
			read -n 1 -t 5 -p "Add emulator windows to the existing session? If no, a new session called emulators will be created. (Y/n): "
			echo
			if [[ $REPLY =~ [Yy] || -z $REPLY ]]; then
				start_emulators "$1" "$session_name"
			else
				tmux new-session -d -s $name
				start_emulators "$1" "$name"
				tmux switch-client -t $name:1
			fi
		fi
	else
		start_emulators "$1" "$name"
	fi
fi
tmux select-window -t :1