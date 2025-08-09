# FZF edit
fe() {
    local file
    file=$(fd --hidden --exclude .git | fzf --preview 'bat --style=numbers --color=always {} | head -500')
    [ -n "$file" ] && nvim "$file"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
