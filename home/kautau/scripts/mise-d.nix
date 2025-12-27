{ pkgs, ... }:

pkgs.writeShellScriptBin "mise-d" ''
    #!/usr/bin/env bash
    set -euo pipefail

    mise upgrade "$@"
    npx tweakcc
''
