#!/usr/bin/env bash
set -euo pipefail

help()
{
    echo "Installs user scripts under ~/bin"
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

if [ ! -d ~/bin ]; then
  mkdir -p ~/bin
fi

for file in *; do
  if [[ " ${exclude_list[@]} " =~ " ${file} " ]]; then
    continue
  fi

  if [[ -f "$file" ]]; then
    echo "Installing $file as ${file%.*} under ~/bin"
    ln -s "$(pwd)/$file" ~/bin/"${file%.*}"
  fi
done
