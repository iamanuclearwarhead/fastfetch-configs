# bash completion for fastfetch-configs

_fastfetch_configs() {
    local cur prev configs share_dir
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    share_dir="/usr/share/fastfetch-configs"
    configs=""
    if [ -d "$share_dir" ]; then
        local dir
        for dir in "$share_dir"/*/; do
            [ -f "$dir/config.jsonc" ] && configs+="$(basename "$dir") "
        done
    fi
    [ -n "$configs" ] || configs="minimal server nordic gruvbox catppuccin tokyo-night matrix verbose"

    case "$prev" in
        -p|--preview)
            COMPREPLY=($(compgen -W "$configs" -- "$cur"))
            return
            ;;
    esac

    if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "-h --help -l --list -p --preview" -- "$cur"))
    elif [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=($(compgen -W "$configs" -- "$cur"))
    fi
}

complete -F _fastfetch_configs fastfetch-configs
