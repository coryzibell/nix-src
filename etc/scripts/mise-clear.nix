{ pkgs, ... }:

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
            ((uninstalled_count++))
        fi
    done <<< "$installed_tools"

    echo ""
    echo "Uninstallation complete! Removed $uninstalled_count tool(s)."
''
