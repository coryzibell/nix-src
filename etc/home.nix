{ config, pkgs, ... }:

{
  home = {
    username = "kautau";
    homeDirectory = "/home/kautau";
    sessionPath = [
      "/home/kautau/.ghcup/bin"
    ];

    shellAliases = {
        vi = "hx";
        vim = "hx";
        nano = "hx";
        ls = "eza --octal-permissions";
        update = "sudo nix-channel --update && sudo nix flake update --flake /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos && mise upgrade && mise prune && ghcup install ghc latest && ghcup install cabal latest && ghcup install stack latest && ghcup install hls latest && ghcup set ghc latest && ghcup set cabal latest && ghcup set stack latest && ghcup set hls latest";
        prune = "ghcup gc --unset && nix-env --delete-generations old && sudo nix-store --gc && nix-collect-garbage -d && sudo nix-collect-garbage -d";
        commit_update = "cd ~/src/nix-src && git add * && git commit -m \"$(openssl dgst -sha256 -binary < /etc/nixos/flake.lock | base100)\"";
      };

      sessionVariables = with pkgs; {
        EDITOR = "hx";
        MISE_NODE_COREPACK = "true";
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      };

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

      gcc
      zlib
      ncurses
      rlwrap
      bc
      openssl.bin
      openssl.dev
      openssl.out
      mesa
      (wxGTK32.override { withWebKit = true; })
      wxc
      automake
      autoconf
      autogen
      pkg-config
      gnumake
      #llvmPackages.clangWithLibcAndBasicRtAndLibcxx
      go
      darcs
      helix
      micro
      emacs
      mercurialFull
      bubblewrap

      nixd
      nil

      php

      xz.out
      zlib.out
    ];
    stateVersion = "25.05";
  };

  programs = {
    
    bash = {
      enable = true;
      # ... other things here
      initExtra = ''
        '';
    };

    zsh = {
      enable = true;
      # ... other things here
      # initExtra = ''
      #   eval "$(mise activate zsh)"
      #   '';
      oh-my-zsh = {
        enable = true;
      };
    };
    
    git = {
      enable = true;
      settings = {
        user.name = "Cory Zibell";
        user.email = "cory@zibell.cloud";
        init.defaultBranch = "main";
        core.sshCommand = "/mnt/c/WINDOWS/System32/OpenSSH/ssh.exe";
      };
    };

    mise = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      globalConfig = {
        settings = {
          all_compile = false;
          exec_auto_install = false;
          jobs = 1;
          # verbose = true;
        };

        tools = {
          node = "latest";
          "cargo:bottom" = "latest";
          "cargo:eza" = "latest";
          "cargo:tealdeer" = "latest";
          "cargo:base100" = "latest";
          "npm:npm" = "latest";
          "npm:cordova" = "latest";
          "npm:@quasar/cli" = "latest";
          "npm:@google/gemini-cli" = "latest";
          cargo-binstall = "latest";
          bun = "latest";
          deno = "latest";
          elixir = "latest";
          erlang = "latest";
          ghcup = "latest";
          go = "latest";
          java = "oracle-graalvm";
          # php = "8.13";
          python = "latest";
          ruby = "latest";
          rust = "latest";
          zig = "latest";
        };
      };

    };

    nushell = {
      enable = true;
      # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      # configFile.source = ./.../config.nu;
      # for editing directly to config.nu 
      
      extraEnv = ''

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
          prepend /home/kautau/.apps |
          append /usr/bin/env
        )
        '';
    };

    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = { 
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };


    home-manager = {
      enable = true;
    };
  };
}
