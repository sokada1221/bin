#!/usr/bin/env bash
set -euo pipefail

help()
{
    echo "Uninstalls user scripts under ~/bin"
    echo "Usage: $(basename "$0") [-n|--dry-run]"
    echo ""
    echo "Options:"
    echo "  -n, --dry-run    Show what would be uninstalled without making changes"
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
  # "scripts/git/"
  # "scripts/github/"
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

# Remove symlinks under ~/bin that point to .sh files in scripts/ directory
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
  
  # Check if the symlink exists and points to our file
  if [[ -L "$target_link" ]]; then
    # Get the target of the symlink
    link_target=$(readlink "$target_link")
    current_file="$(pwd)/$file"
    
    # Check if the symlink points to our file
    if [[ "$link_target" == "$current_file" ]]; then
      if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY RUN] Would uninstall ~/bin/$basename (-> $rel_path)"
      else
        echo "Uninstalling ~/bin/$basename (-> $rel_path)"
        rm -f "$target_link"
      fi
    else
      echo "Skipping ~/bin/$basename (points to different file: $link_target)"
    fi
  fi
done < <(find scripts -name "*.sh" -type f -print0 2>/dev/null)
