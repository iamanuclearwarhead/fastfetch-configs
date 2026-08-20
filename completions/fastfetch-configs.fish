# fish completion for fastfetch-configs

function __fastfetch_configs_list
    set -l share_dir /usr/share/fastfetch-configs
    if test -d $share_dir
        for dir in $share_dir/*/
            if test -f $dir/config.jsonc
                basename $dir
            end
        end
    else
        printf '%s\n' minimal server nordic gruvbox catppuccin tokyo-night matrix verbose
    end
end

complete -c fastfetch-configs -f
complete -c fastfetch-configs -s h -l help -d 'show help'
complete -c fastfetch-configs -s l -l list -d 'list available configs'
complete -c fastfetch-configs -s p -l preview -x -a '(__fastfetch_configs_list)' -d 'preview a config without installing'
complete -c fastfetch-configs -n '__fish_is_first_arg' -a '(__fastfetch_configs_list)' -d 'config'
