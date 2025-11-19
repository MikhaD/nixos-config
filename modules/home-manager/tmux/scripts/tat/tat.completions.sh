_tat_completions() {
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "$(tmux ls 2> /dev/null | cut -d: -f1) --new --help" -- "${COMP_WORDS[1]}"))
    elif [[ $COMP_CWORD -eq 2 && (${COMP_WORDS[1]} == "-n" || ${COMP_WORDS[1]} == "--new") ]]; then
        COMPREPLY=($(compgen -W "$(tmux ls 2> /dev/null | cut -d: -f1)" -- "${COMP_WORDS[2]}"))
    fi
}

complete -F _tat_completions tat