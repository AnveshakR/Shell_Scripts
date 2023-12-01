#!/bin/bash

directory=$(pwd)
session_name="$(basename "$directory")"

tmux new-session -d -s "$session_name" -n "main" 

# Set up panes
tmux send-keys -t $session_name "nvim ." C-m

tmux split-window -v -p 33 

# Check if .python-version file exists
python_version_file=".python-version"
if [ -f "$python_version_file" ];
then
  env_name="$(cat $python_version_file)"
  if conda env list | grep -q $env_name 
    then
      tmux send-keys "conda activate $env_name" C-m
  elif pyenv versions | grep -q $env_name 
    then
      tmux send-keys "pyenv activate $env_name" C-m
  fi
fi

# Attach to the session
# tmux select-pane -t 0
tmux attach-session -t "$session_name"
