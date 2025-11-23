# Personal aliases and functions
# Source this at the end of ~/.zshrc

# Add user scripts under ~/bin to PATH
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# Set up direnv
# Prerequisites:
# - brew install direnv
# Reference: https://direnv.net/docs/hook.html#zsh
if command -v direnv 2>&1 > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Set up kubectl plugins
# Prerequisites:
# - brew install krew
# krew plugins
# - kubectl krew install who-can
# - kubectl krew install deprecations
# - kubectl krew install access-matrix
# - kubectl krew install score
# - kubectl krew install get-all
# - kubectl krew install tree
# - kubectl krew install outdated
if [ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# zsh plugins
# - zsh-you-should-use (https://github.com/MichaelAquilina/zsh-you-should-use)
# - zsh-bat (https://github.com/fdellwing/zsh-bat)

# Set up fzf
# Prerequisites:
# - brew install fzf
# Reference: https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
## Set up fzf key bindings and fuzzy completion
if command -v fzf 2>&1 > /dev/null; then
  source <(fzf --zsh)
fi

# Set up ^g to fuzzy search git repositories
# Prerequisites:
# - brew install ghq
# - brew install bat
# Reference: https://zenn.dev/mozumasu/articles/mozumasu-lazy-git#%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E3%81%AB%E3%82%B5%E3%82%AF%E3%83%83%E3%81%A8%E7%A7%BB%E5%8B%95(ghq%2C-fzf)
if command -v ghq >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
  function ghq-fzf() {
    local selection=$(ghq list | fzf --expect=ctrl-o --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
    local key=$(echo "$selection" | head -1)
    local src=$(echo "$selection" | tail -n +2)

    if [ -n "$src" ]; then
      if [ "$key" = "ctrl-o" ]; then
        open "https://$src"
      else
        BUFFER="cd $(ghq root)/$src"
        zle accept-line
      fi
    fi
    zle -R -c
  }
  zle -N ghq-fzf
  bindkey '^g' ghq-fzf
fi

# Set up asdf
# Prerequisites:
# - brew install asdf
# - add asdf zsh plugin to ~/.zshrc
# Reference: https://asdf-vm.com/guide/getting-started.html#_2-configure-asdf
if [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# Set up zsh-autosuggestions & zsh-syntax-highlighting
# Note: This MUST be sourced at the end
# Prerequisites:
# - brew install zsh-syntax-highlighting
# - brew install zsh-autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  # Adjustment for iTerm2 solarized dark theme
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
