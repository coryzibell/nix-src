{ config, pkgs, ... }:

{
  home = {
    username = "kautau";
    homeDirectory = "/home/kautau";
    sessionPath = [ ];

    packages = with pkgs; [
      fastfetch
      nnn # terminal file manager

      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processor https://github.com/mikefarah/yq
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils  # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc  # it is a calculator for the IPv4/v6 addresses

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg
      findutils

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      hugo # static site generator
      glow # markdown previewer in terminal

      btop  # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb

      mise

      gcc
      zlib
      ncurses
      rlwrap
      openssl.dev
      mesa
      (wxGTK32.override { withWebKit = true; })
      wxc
      automake
      autoconf
      autogen
      gnumake
      #llvmPackages.clangWithLibcAndBasicRtAndLibcxx
      go
      darcs
      helix
      emacs
      mercurialFull
      bubblewrap
    ];
    stateVersion = "24.11";
  };

  programs = {
    
    bash = {
      enable = true;
      # ... other things here
      initExtra = ''
        eval "$(mise activate bash)"
        '';
    };
    
    git = {
      enable = true;
      extraConfig = {
        user.name = "Cory Zibell";
        user.email = "cory@zibell.cloud";
        init.defaultBranch = "main";
        core.sshCommand = "ssh.exe";
      };
    };

    nushell = { enable = true;
      # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      # configFile.source = ./.../config.nu;
      # for editing directly to config.nu 
      
      extraEnv = ''
        let mise_path = $nu.default-config-dir | path join mise.nu
        ^mise activate nu | save $mise_path --force
      '';
      
      extraConfig = ''
        $env.config.hooks.env_change = {}
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
          show_banner: false,
          hooks: {
            command_not_found: {|cmd|
              let output = (run-external command-not-found $cmd)
              if $output != "" {
                echo $output
              } else {
                echo "Command '$cmd' not found."
              }
            }
          },
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
                enable: true 
              # set to lower can improve completion performance at the cost of omitting some options
                max_results: 100 
                completer: $carapace_completer # check 'carapace_completer' 
            }
          }
        } 
        $env.PATH = ($env.PATH | 
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
        )
        use ($nu.default-config-dir | path join mise.nu)
        '';
        shellAliases = {
          vi = "hx";
          vim = "hx";
          nano = "hx";
        };
      };  
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = { enable = true;
      settings = {
        add_newline = false;
        character = { 
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    home-manager.enable = true;
  };
}
