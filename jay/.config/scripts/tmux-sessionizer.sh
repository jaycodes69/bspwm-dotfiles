#!/usr/bin/env bash
#
# tmux-sessionizer.sh
#
# A helper script to quickly jump between project directories inside tmux.
# - Lists projects from SEARCH_DIRS
# - Lets you pick one with fzf + eza + bat preview
# - Opens / switches to the corresponding tmux session
#
# Requirements:
#   tmux, fzf, eza, bat (optional but recommended)
#

######################################
# CONFIGURATION
######################################

# Directories to scan for projects
# Each directory is searched up to a maximum depth for subprojects
SEARCH_DIRS=(
  "$HOME/personal"
  "$HOME/.dotfiles"
)

# Maximum depth for scanning projects (2 means ~/personal/project/subproject is included)
MAX_DEPTH=4

# Directories to ignore while scanning (patterns for `find`)
IGNORE_DIRS=(
  ".git"
  "node_modules"
  "__pycache__"
  "target"
  "build"
)

######################################
# FUNCTION: Build the find command filters
######################################
# This builds the `find` exclusion arguments dynamically from IGNORE_DIRS
build_find_excludes() {
  local args=()
  for ignore in "${IGNORE_DIRS[@]}"; do
    args+=(! -name "$ignore" ! -path "*/$ignore/*")
  done
  echo "${args[@]}"
}

######################################
# MAIN: Pick a project
######################################

if [[ $# -eq 1 ]]; then
  # If the user passed an argument, use it directly
  selected=$1
else
  # Otherwise, search for directories interactively with fzf
  # --preview shows a tree view with eza, and if README exists, show it with bat
  selected=$(find "${SEARCH_DIRS[@]}" \
    -mindepth 1 -maxdepth "$MAX_DEPTH" -type d \
    $(build_find_excludes) \
    | fzf \
    --preview '
  if [[ -f {}/README.md ]]; then
    bat --style=plain --color=always --line-range=:100 {}/README.md
  else
    eza --tree --level=2 --color=always {}
fi
' \
  --preview-window=right:50%:wrap \
  --bind "ctrl-o:execute(tmux new-window -c {} >/dev/tty)" \
  --height=90% --border --prompt="Select project: "
)
fi

# Exit if nothing selected
[[ -z $selected ]] && exit 0

######################################
# Give selected path to tmux session name
######################################
selected_name=$(basename "$selected")

######################################
# Check if tmux is already running
######################################
tmux_running=$(pgrep tmux)

######################################
# If tmux is NOT running, start a new session in the selected project
######################################
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

######################################
# If session does not exist yet, create it detached
######################################
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

######################################
# Attach or switch to the session
######################################
if [[ -z $TMUX ]]; then
  # Not inside tmux → attach to the session
  tmux attach -t "$selected_name"
else
  # Already inside tmux → switch to the session
  tmux switch-client -t "$selected_name"
fi
