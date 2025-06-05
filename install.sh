#!/usr/bin/env bash
set -euo pipefail

help()
{
    echo "Installs user scripts under ~/bin"
    echo "Usage: $(basename "$0") [-n|--dry-run]"
    echo ""
    echo "Options:"
    echo "  -n, --dry-run    Show what would be installed without making changes"
}

error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# Parse command line arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      help >&2
      exit 1
      ;;
  esac
done

# Gitignore-style exclusion patterns
exclude_patterns=(
  "install.sh"
  "uninstall.sh"
  "configs/"
  "scripts/lyft/"
  "scripts/tmux/"
)

# Function to check if a path matches any exclusion pattern
is_excluded() {
  local path="$1"
  local pattern
  
  for pattern in "${exclude_patterns[@]}"; do
    # Handle directory patterns (ending with /)
    if [[ "$pattern" == */ ]]; then
      if [[ "$path" == "$pattern"* ]]; then
        return 0
      fi
    # Handle wildcard patterns
    elif [[ "$pattern" == *"*"* ]]; then
      if [[ "$path" == $pattern ]]; then
        return 0
      fi
    # Handle exact matches
    else
      if [[ "$path" == "$pattern" ]]; then
        return 0
      fi
    fi
  done
  return 1
}

if [ ! -d ~/bin ]; then
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would create directory ~/bin"
  else
    mkdir -p ~/bin
    echo "Created directory ~/bin"
  fi
fi

# Find all .sh files in scripts/ directory recursively
while IFS= read -r -d '' file; do
  # Get relative path from current directory
  rel_path="${file#./}"
  
  # Skip if excluded
  if is_excluded "$rel_path"; then
    continue
  fi
  
  # Extract filename without path and extension for symlink name
  basename=$(basename "$file" .sh)
  target_link="$HOME/bin/$basename"
  
  # Check if symlink already exists
  if [[ -L "$target_link" ]]; then
    echo "Skipping $rel_path (symlink ~/bin/$basename already exists)"
    continue
  elif [[ -e "$target_link" ]]; then
    echo "Skipping $rel_path (file ~/bin/$basename already exists and is not a symlink)"
    continue
  fi
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would install $rel_path as ~/bin/$basename"
  else
    echo "Installing $rel_path as ~/bin/$basename"
    ln -s "$(pwd)/$file" "$target_link"
  fi
done < <(find scripts -name "*.sh" -type f -print0 2>/dev/null)
