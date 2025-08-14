# Tmux
alias t="tmux new -A -s main"
alias tl="tmux ls"
alias ta="tmux attach -t"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"

# Neovim
alias v="nvim"
alias vi="nvim"


alias discord="discordo -t MTM5MzgxMTY3NTU5MjkyMTE1OA.GiU_8z.XRSkIeO2ORU9ZZdRfqGBffK2_Sa0PSMslYGX04"

# Eza
alias l="eza -A --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -lha --icons --group-directories-first"
alias tree="eza --tree --icons --group-directories-first"

# FD + FZF + Ripgrep

alias ff="fd --hidden --exclude .git | fzf --preview 'bat --style=numbers --color=always {} | head -500'"

alias fg="rg --hidden --glob '!.git' --line-number --color=always | fzf --ansi --preview 'bat --style=numbers --color=always {1} --highlight-line {2}'"

alias fh="history | fzf"

alias fkill="ps -ef | fzf --preview 'echo {}' | awk '{print \$2}' | xargs kill -9"
