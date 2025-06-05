#!/usr/bin/env bash
set -eo pipefail

help()
{
    echo "Usage: $(basename "$0") [ssh-args] hostname"
}

error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if [[ -z "$1" ]]; then
  help
  exit 1
fi

set -u

# ssh "$@" -t 'tmux -CC new -A -s sokada'
ssh -XY "$@" -Ct 'sh -l -c "exec tmux -CC -u new-session -AD -s sokada"'
