{ ... }:

{
  enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  autosuggestion.enable = true;
  oh-my-zsh = {
    enable = true;
    plugins = [
      # Version Control
      "git"              # Git aliases and functions
      "gitignore"        # Generate .gitignore files from gitignore.io
      "github"           # GitHub CLI shortcuts
      
      # Container & Orchestration
      "docker"           # Docker completions
      "docker-compose"   # Docker Compose completions
      "kubectl"          # Kubernetes completions
      
      # Programming Languages
      "node"             # Node.js completions
      "npm"              # npm completions and aliases
      "bun"              # Bun completions
      "deno"             # Deno completions
      "golang"           # Go completions
      "rust"             # Rust completions
      "python"           # Python completions
      "pip"              # pip completions
      "ruby"             # Ruby completions
      "gem"              # RubyGems completions
      
      # System Utilities
      "sudo"             # Press ESC twice to add sudo to previous command
      "systemd"          # systemd aliases (sc-status, sc-start, etc.)
      "command-not-found" # Suggests packages for missing commands
      
      # Navigation & History
      "dirhistory"       # Navigate directory history with Alt+arrows
      "z"                # Jump to frequently used directories
      "history"          # History aliases
      "zsh-navigation-tools" # Advanced navigation UI (n-history, n-cd, n-kill)
      
      # Clipboard Operations
      "copypath"         # Copy current path to clipboard
      "copyfile"         # Copy file contents to clipboard
      "copybuffer"       # Ctrl+O to copy current command line to clipboard
      
      # Productivity & Display
      "colored-man-pages" # Colorized man pages
      "extract"          # Universal extract command for archives
      "jsontools"        # JSON formatting tools (pp_json, is_json, etc.)
      "web-search"       # Search from terminal (google, stackoverflow, etc.)
      "aliases"          # Search aliases with 'acs' command
      "timer"            # Show execution time for long commands
    ];
  };
}
