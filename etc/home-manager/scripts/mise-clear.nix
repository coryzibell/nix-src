{ pkgs, ... }:

# Uninstalls all mise tools except those explicitly listed.
# Purpose: If you uninstall node/npm but have npm tools listed in config,
# mise will loop fail trying to run npm to check the tool status on every shell prompt.
pkgs.writeShellScriptBin "mise-clear" ''
    #!/usr/bin/env bash

    set -euo pipefail

    # Get all installed tools from mise
    echo "Fetching installed mise tools..."
    installed_tools=$(mise list --installed 2>/dev/null | awk '{print $1}' | sort -u)

    # Tools to keep
    keep_tools=("node" "npm:npm")

    # Counter for uninstalled tools
    uninstalled_count=0

    echo "Starting uninstallation process..."
    echo "Tools to keep: ''${keep_tools[*]}"
    echo ""

    # Loop through each installed tool
    while IFS= read -r tool; do
        # Skip empty lines
        [[ -z "$tool" ]] && continue

        # Check if tool should be kept
        if [[ " ''${keep_tools[*]} " =~ " ''${tool} " ]]; then
            echo "Keeping: $tool"
        else
            echo "Uninstalling: $tool"
            mise uninstall "$tool" -a || echo "Failed to uninstall $tool"
            uninstalled_count=$((uninstalled_count + 1))
        fi
    done <<< "$installed_tools"

    echo ""
    echo "Uninstallation complete! Removed $uninstalled_count tool(s)."
    echo ""
    echo "Clearing mise cache..."
    mise cache clear
    echo "Cache cleared successfully!"
''
