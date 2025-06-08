# Personal Bin Scripts & Configs

A collection of personal shell scripts and configuration files for streamlined development workflow and system setup.

## 🚀 Quick Start

```bash
# Install scripts (dry run first)
./install.sh --dry-run
./install.sh

# Uninstall scripts (dry run first)
./uninstall.sh --dry-run
./uninstall.sh

# Configs currently require manual installation/uninstallation
# See instructions at the top of each config file
```

## 📁 Repository Structure

```
bin/
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
├── scripts/                # Shell scripts
│   ├── git/               # Git-related utilities
│   ├── github/            # GitHub workflow scripts
│   ├── lyft/              # Lyft-specific tools
│   └── tmux/              # Terminal multiplexer utilities
└── configs/               # Configuration files
    ├── vim/               # Vim configurations
    └── zsh/               # Zsh shell configurations
```

## 🚦 Exclusion Patterns

The installation scripts support gitignore-style exclusion patterns:

```bash
exclude_patterns=(
  "install.sh"          # Exact file matches
  "uninstall.sh"        
  "*.tmp"               # Wildcard patterns
  "*.log"               
  ".git/"               # Directory exclusions
  "README.md"           
)
```
