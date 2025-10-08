_emulators_completions() {
	if [[ ${COMP_WORDS[COMP_CWORD-1]} = "--container-tool" || ${COMP_WORDS[COMP_CWORD-1]} = "-C" ]]; then
		COMPREPLY=($(compgen -W "docker podman" -- "${COMP_WORDS[COMP_CWORD]}"))
	elif [[ $COMP_CWORD -eq 1 ]]; then
		COMPREPLY=($(compgen -W "start stop attach list preset" -- "${COMP_WORDS[COMP_CWORD]}"))
	elif [[ $COMP_CWORD -eq 2 ]]; then
		case "${COMP_WORDS[1]}" in
			start|stop)
				COMPREPLY=($(compgen -W "$(emulators list)" -- "${COMP_WORDS[COMP_CWORD]}"))
				;;
			preset)
				COMPREPLY=($(compgen -W "list show" -- "${COMP_WORDS[COMP_CWORD]}"))
				;;
			config)
				COMPREPLY=($(compgen -W "init show edit" -- "${COMP_WORDS[COMP_CWORD]}"))
				;;
			*)
				COMPREPLY=()
				;;
		esac
	elif [[ $COMP_CWORD -eq 3 ]]; then
		if [[ ${COMP_WORDS[1]} = "preset" && ${COMP_WORDS[2]} = "show" ]]; then
			COMPREPLY=($(compgen -W "$(emulators preset list)" -- "${COMP_WORDS[COMP_CWORD]}"))
		else
			COMPREPLY=()
		fi
	elif [[ ${COMP_WORDS[COMP_CWORD-1]} = "--preset" || ${COMP_WORDS[COMP_CWORD-1]} = "-p" ]]; then
		COMPREPLY=($(compgen -W "$(emulators preset list)" -- "${COMP_WORDS[COMP_CWORD]}"))
	fi
}

complete -F _emulators_completions emulators

# Ensure emulators flags cannot come after a subcommand
# Tab complete flags if current word starts with a dash
# Do not include emulators in completion list if they have already been specified
# Do not include presets in completion list if they have already been specified
# Stop and start list only complete for the first emulator (check if it works if there is a preset before)
# Completion for -d flag should only work if the sub command supports presets