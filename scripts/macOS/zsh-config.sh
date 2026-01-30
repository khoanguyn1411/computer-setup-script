# Homebrew (Apple Silicon)
if [[ $(uname -m) == 'arm64' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load shared zsh configuration
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
source "$SCRIPT_DIR/../../shared/zsh-config.sh"

# Homebrew
alias brewup="brew update && brew upgrade && brew cleanup"
