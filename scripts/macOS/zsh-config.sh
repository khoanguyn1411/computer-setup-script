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

function zshUpdate() {
    local REPO_URL="https://github.com/khoanguyn1411/computer-setup-script.git"
    local TEMP_DIR=$(mktemp -d)
    
    echo "🔄 Updating zsh configuration from GitHub..."
    
    # Clone the repo to temp directory
    echo "📥 Fetching latest changes from GitHub..."
    if git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1; then
        local SHARED_CONFIG="$TEMP_DIR/shared/zsh-config.sh"
        local OS_CONFIG="$TEMP_DIR/scripts/macOS/zsh-config.sh"
        
        # Check if files exist
        if [ ! -f "$SHARED_CONFIG" ] || [ ! -f "$OS_CONFIG" ]; then
            echo "❌ Error: Configuration files not found in repository"
            rm -rf "$TEMP_DIR"
            return 1
        fi
        
        echo "📝 Updating ~/.zshrc with latest configuration..."
        
        # Build .zshrc: Homebrew initialization + shared + macOS-specific
        head -n 4 "$OS_CONFIG" > "$HOME/.zshrc"
        echo "" >> "$HOME/.zshrc"
        cat "$SHARED_CONFIG" >> "$HOME/.zshrc"
        echo "" >> "$HOME/.zshrc"
        echo "# macOS specific configurations" >> "$HOME/.zshrc"
        tail -n +6 "$OS_CONFIG" | tail -n +3 >> "$HOME/.zshrc"
        
        echo "✅ Configuration updated (macOS + shared)"
        
        # Reload the configuration
        echo "🔄 Reloading shell configuration..."
        source "$HOME/.zshrc"
        echo "✨ Done! Your zsh is now up to date."
    else
        echo "❌ Error: Failed to fetch repository from GitHub"
        rm -rf "$TEMP_DIR"
        return 1
    fi
    
    # Clean up temp directory
    echo "🧹 Cleaning up..."
    rm -rf "$TEMP_DIR"
}
