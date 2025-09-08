_emulators_completions() {
	if [[ $COMP_CWORD -eq 1 ]]; then
		COMPREPLY=( $(compgen -W "default postgres testing" -- "${COMP_WORDS[COMP_CWORD]}") )
	fi
}

complete -F _emulators_completions emulators