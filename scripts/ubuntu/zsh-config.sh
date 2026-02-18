# Ubuntu specific configurations

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# IDE
# Detect WSL vs native Ubuntu and configure IDE shortcuts accordingly
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    # WSL: Use launcher scripts for WSL remote connection
    alias wf="source ~/windsurf-launcher.sh"
    alias ag="source ~/antigravity-launcher.sh; antigravity"
else
    # Native Ubuntu: Launch applications directly
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
fi

function zshUpdate() {
    local REPO_URL="https://github.com/khoanguyn1411/computer-setup-script.git"
    local TEMP_DIR=$(mktemp -d)
    
    echo "🔄 Updating zsh configuration from GitHub..."
    
    # Clone the repo to temp directory
    echo "📥 Fetching latest changes from GitHub..."
    if git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1; then
        local SHARED_CONFIG="$TEMP_DIR/shared/zsh-config.sh"
        local OS_CONFIG="$TEMP_DIR/scripts/ubuntu/zsh-config.sh"
        
        # Check if files exist
        if [ ! -f "$SHARED_CONFIG" ] || [ ! -f "$OS_CONFIG" ]; then
            echo "❌ Error: Configuration files not found in repository"
            rm -rf "$TEMP_DIR"
            return 1
        fi
        
        echo "📝 Updating ~/.zshrc with latest configuration..."
        
        # Build .zshrc: shared + Ubuntu-specific
        cat "$SHARED_CONFIG" > "$HOME/.zshrc"
        echo "" >> "$HOME/.zshrc"
        echo "# Ubuntu specific configurations" >> "$HOME/.zshrc"
        tail -n +3 "$OS_CONFIG" >> "$HOME/.zshrc"
        
        echo "✅ Configuration updated (Ubuntu + shared)"
        
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
