#!/bin/bash
set -eo pipefail

if [[ -z "$1" ]]; then
    me="${FUNCNAME[0]}${funcstack[1]}"
    echo "usage: $me [ssh-args] hostname"
    exit 1
fi

set -u

# ssh "$@" -t 'tmux -CC new -A -s sokada'
ssh -XY "$@" -Ct 'sh -l -c "exec tmux -CC -u new-session -AD -s sokada"'
