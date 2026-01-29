#!/bin/bash
# ensure-permissions.sh
# Utility to auto-fix execute permission for the calling script
# Usage: source this file at the beginning of any .sh script

# BASH_SOURCE[1] contains the path of the script that sourced this file
CALLER_SCRIPT="${BASH_SOURCE[1]}"

if [[ -n "$CALLER_SCRIPT" && -f "$CALLER_SCRIPT" && ! -x "$CALLER_SCRIPT" ]]; then
    chmod +x "$CALLER_SCRIPT" 2>/dev/null || true
fi