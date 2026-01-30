# Load shared zsh configuration
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
source "$SCRIPT_DIR/../../shared/zsh-config.sh"

# Ubuntu specific configurations

# IDE
# Detect WSL vs native Ubuntu and configure IDE shortcuts accordingly
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    # WSL: Use launcher scripts for WSL remote connection
    alias wf="source ~/windsurf-launcher.sh"
    alias ag="source ~/antigravity-launcher.sh"
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
