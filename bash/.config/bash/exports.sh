# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Terminal Defaults
export TERMINAL="kitty"
export TERM="kitty"
export EDITOR="nvim"
export VISUAL="nvim"

# Alacritty
export ALACRITTY_CONFIG_PATH="$XDG_CONFIG_HOME/alacritty/alacritty.toml"

# Tools
export BAT_THEME="Dracula"
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK_THEME="Dracula"

# History
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000
shopt -s histappend

# FZF defaults
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"

