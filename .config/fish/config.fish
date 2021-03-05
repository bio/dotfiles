zoxide init fish | source

# define environment variables to support fzf.vim
set --export FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# ripgrep
set --export RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/ripgreprc"

# disable fish greeting
set fish_greeting 

# set colors
set fish_color_command black
set fish_color_cwd blue
set fish_color_search_match --background='#eeeeee'
set fish_pager_color_completion normal
set fish_pager_color_prefix black --underline

# import local config
set local_config ~/.config/fish/config.local.fish
test -r $local_config; and source $local_config
