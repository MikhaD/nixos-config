#!/usr/bin/env bash
VERSION="<REPLACED IN INSTALL PHASE>"

list_tmux_sessions_for_fzf() {
    for name in $(tmux ls | cut -d: -f1); do
        echo "$name: ($(tmux list-windows -t $name -F "#{window_name}" | paste -sd ',' | sed 's/,/, /g'))"
    done
}

count=$(tmux ls 2> /dev/null | wc -l)
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage: tat [-n] [-h] [<session name>]"
	echo
	echo "Tmux ATtach (tat) script to improve navigation between tmux sessions."
	echo "Use without arguments to enter tmux session selection menu if in tmux and there are multiple sessions."
	echo "- If not in tmux and there are multiple sessions present a fzf menu to select a session to attach to."
	echo "- If not in tmux and there is only one session attach to that session."
	echo "- If in tmux and there is only one session do nothing."
	echo
	echo "options:"
	echo "  -h, --help          Show this help message and exit."
	echo "  -n, --new           Create a tmux session with the given session name if no session exists, else attach to"
	echo "                      the given session."
	exit 0
fi
[[ $count -eq 0 ]] && exit 1
if [[ -n $1 ]]; then
	if [[ $1 == "-n" || $1 == "--new" ]]; then
		tmux new-session -d -t "$2"
		shift
	fi
	if tmux has-session -t $1 &> /dev/null; then
		if [[ -z $TMUX ]]; then
			tmux attach-session -t $1 &> /dev/null
		else
			tmux switch-client -t $1 &> /dev/null
		fi
		exit $?
	else
		exit 1
	fi
fi
if [[ $count -eq 1 ]]; then
	if [[ -z $TMUX ]]; then
		tmux attach-session
	fi
	exit 0
	else
	if [[ -z $TMUX ]]; then
		session=$(list_tmux_sessions_for_fzf | fzf --info-command='echo -e "$FZF_INFO Select Tmux Session"')
		if [[ -z $session ]]; then
			exit 1
		fi
		tmux attach-session -t "${session%%:*}"
	else
		tmux choose-tree
	fi
fi