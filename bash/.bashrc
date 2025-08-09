#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for file in ~/.config/bash/*.sh; do
    [ -r "$file" ] && source "$file"
done

eval "$(zoxide init bash --cmd j)"

PS1='\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h \[\e[1;34m\]\w \[\e[0m\]\$ '
