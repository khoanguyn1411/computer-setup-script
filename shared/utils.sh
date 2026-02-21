#!/usr/bin/env bash

# Utility functions for setup scripts

# Check if running in WSL
is_wsl() {
    grep -qiE "microsoft|wsl" /proc/version 2>/dev/null
    return $?
}

# Check if NOT running in WSL
is_not_wsl() {
    ! is_wsl
    return $?
}

# Check if running in CI environment
is_ci() {
    [ "$SETUP_ENV" = "ci" ]
    return $?
}

# Check if running in local environment (not CI)
is_local() {
    [ "$SETUP_ENV" != "ci" ]
    return $?
}
