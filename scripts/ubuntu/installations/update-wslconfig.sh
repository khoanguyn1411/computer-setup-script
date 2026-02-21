#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../../shared/colors.sh"
source "$SCRIPT_DIR/../../shared/utils.sh"

# Check if running in WSL
if is_not_wsl; then
  print_warning "This script is only for WSL environments"
  print_info "Skipping WSL config update (not running in WSL)"
  exit 0
fi

print_header "UPDATING WSL CONFIG"

# Detect Windows username
WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

if [ -z "$WIN_USER" ]; then
  print_error "Could not detect Windows username"
  exit 1
fi

WSLCONFIG_PATH="/mnt/c/Users/$WIN_USER/.wslconfig"

print_step "Configuring WSL settings for user: $WIN_USER"

# Create backup if file exists
if [ -f "$WSLCONFIG_PATH" ]; then
  BACKUP_PATH="${WSLCONFIG_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$WSLCONFIG_PATH" "$BACKUP_PATH"
  print_info "Backup created: $BACKUP_PATH"
fi

# Read existing config or create new one
if [ -f "$WSLCONFIG_PATH" ]; then
  EXISTING_CONTENT=$(cat "$WSLCONFIG_PATH")
else
  EXISTING_CONTENT=""
  print_info ".wslconfig file doesn't exist, creating new one"
fi

# Check if [wsl2] section exists
if echo "$EXISTING_CONTENT" | grep -q "^\[wsl2\]"; then
  print_step "Updating existing [wsl2] section..."
  
  # Use awk to update or add memory and processors
  awk -v memory="32GB" -v processors="12" '
    BEGIN { in_wsl2=0; memory_set=0; processors_set=0 }
    /^\[wsl2\]/ { in_wsl2=1; print; next }
    /^\[.*\]/ { 
      if (in_wsl2 && !memory_set) { print "memory=" memory; memory_set=1 }
      if (in_wsl2 && !processors_set) { print "processors=" processors; processors_set=1 }
      in_wsl2=0 
    }
    in_wsl2 && /^memory=/ { print "memory=" memory; memory_set=1; next }
    in_wsl2 && /^processors=/ { print "processors=" processors; processors_set=1; next }
    { print }
    END { 
      if (in_wsl2 && !memory_set) { print "memory=" memory }
      if (in_wsl2 && !processors_set) { print "processors=" processors }
    }
  ' "$WSLCONFIG_PATH" > "${WSLCONFIG_PATH}.tmp"
  
  mv "${WSLCONFIG_PATH}.tmp" "$WSLCONFIG_PATH"
else
  print_step "Adding new [wsl2] section..."
  
  # Append [wsl2] section to existing content or create new file
  {
    if [ -n "$EXISTING_CONTENT" ]; then
      echo "$EXISTING_CONTENT"
      echo ""
    fi
    echo "[wsl2]"
    echo "memory=32GB"
    echo "processors=12"
  } > "$WSLCONFIG_PATH"
fi

# Convert line endings to Windows format
unix2dos "$WSLCONFIG_PATH" 2>/dev/null || sed -i 's/$/\r/' "$WSLCONFIG_PATH"

print_success "memory=32GB"
print_success "processors=12"
print_done "WSL config updated successfully!"
echo ""
print_warning "Restart WSL for changes to take effect:"
print_info "Run in PowerShell: wsl --shutdown"
print_info "Then restart your WSL terminal"
