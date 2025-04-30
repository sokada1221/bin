#!/usr/bin/env bash
set -euo pipefail

help()
{
    echo "Uninstalls user scripts under ~/bin"
    echo "Usage: $(basename "$0")"
}

error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

exclude_list=(
  "install.sh"
  "uninstall.sh"
  "zshrc_lyft.zsh"
  "zshrc_personal.zsh"
)

# Remove symlinks under ~/bin that point to this directory
for file in *; do
  if [[ " ${exclude_list[@]} " =~ " ${file} " ]]; then
    continue
  fi

  # Check if the symlink exists
  if [[ -L ~/bin/"${file%.*}" ]]; then
    echo "Uninstalling ~/bin/${file%.*}"
    rm -f ~/bin/"${file%.*}"
  fi
done
