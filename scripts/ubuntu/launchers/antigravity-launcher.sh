antigravity() {
    local DISTRO=$WSL_DISTRO_NAME
    local AG_EXE=$(find /mnt/*/App/antigravity -name "antigravity" -type f -executable 2>/dev/null | head -n 1)
    
    if [ -z "$AG_EXE" ]; then
        echo "Error: Antigravity executable not found"
        return 1
    fi
    
    "$AG_EXE" --remote wsl+$DISTRO "$(pwd)"
}

antigravity