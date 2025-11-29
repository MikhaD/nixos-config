_retcon_completions() {
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "--help --reverse --version" -- "${COMP_WORDS[1]}"))
    fi
}

complete -F _retcon_completions retcon