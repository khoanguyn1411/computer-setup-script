# Homebrew (Apple Silicon)
if [[ $(uname -m) == 'arm64' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# macOS specific configurations

# IDE
function wf() {
    if ! command -v windsurf &> /dev/null; then
        echo "Error: windsurf is not installed"
        return 1
    fi
    
    local target_path="${1:-.}"
    # Launch in background with output redirected for cleaner terminal experience
    # If you need to debug, remove '&> /dev/null' to see error messages
    windsurf "$target_path" &> /dev/null &
}

function ag() {
    if ! command -v antigravity &> /dev/null; then
        echo "Error: antigravity is not installed"
        return 1
    fi
    
    local target_path="${1:-.}"
    # Launch in background with output redirected for cleaner terminal experience
    # If you need to debug, remove '&> /dev/null' to see error messages
    antigravity "$target_path" &> /dev/null &
}

# Homebrew
alias brewup="brew update && brew upgrade && brew cleanup"
