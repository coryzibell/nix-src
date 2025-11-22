{ config, pkgs, lib, ... }:

let
  # Combined development libraries for mise and general development
  devLibs = pkgs.symlinkJoin {
    name = "dev-libs";
    paths = with pkgs; [
      # GTK/GUI libraries and dependencies
      atk.dev
      atk.out
      cairo.dev
      cairo.out
      gdk-pixbuf.dev
      gdk-pixbuf.out
      glib.dev
      glib.out
      libGL.dev
      libGL.out
      libGLU.dev
      libGLU.out
      gtk3.dev
      gtk3.out
      harfbuzz.dev
      harfbuzz.out
      libepoxy.dev
      libepoxy.out
      libpng.dev
      libpng.out
      libsysprof-capture
      pango.dev
      pango.out
      pcre2.dev
      pcre2.out
      sysprof.dev
      sysprof.lib
      sysprof.out
      
      # Core build libraries
      bison
      bzip2.dev
      bzip2.out
      curl.bin
      curl.dev
      curl.out
      fontconfig.dev
      fontconfig.lib
      fontconfig.out
      freetype.dev
      freetype.out
      gd.bin
      gd.dev
      gd.out
      gdbm.dev
      gdbm.out
      gdbm.lib
      gettext
      gmp.out
      gmp.dev
      glibc.dev
      glibc.out
      glibc.bin
      glibc.static
      glfw
      icu.dev
      icu.out
      libbacktrace
      libedit.dev
      libedit.out
      libffi.dev
      libffi.out
      libGLU
      libglvnd.dev
      libglvnd.out
      libiconv
      libuuid.bin
      libuuid.dev
      libuuid.out
      libx11.dev
      libx11.out
      libxml2.bin
      libxml2.dev
      libxml2.out
      libyaml.dev
      libyaml.out
      mesa.out
      mpdecimal.dev
      mpdecimal.out
      ncurses.dev
      ncurses.out
      ncurses5
      openssl.bin
      openssl.dev
      openssl.out
      re2c
      readline.dev
      readline.out
      sqlite.dev
      sqlite.out
      tcl
      wayland.dev
      wayland.out
      wayland-protocols
      libxkbcommon.dev
      libxkbcommon.out
      tk
      tk.dev
      tk.out
      unixODBC
      xorg.libXft.dev
      xorg.libXft.out
      xorg.libXinerama.dev
      xorg.libXinerama.out
      xorg.xorgproto
      xz.dev
      xz.out
      zlib.dev
      zlib.out

      libavif.dev
      libavif.out

      libwebp

      libjpeg.dev
      libjpeg.out
      libjpeg.bin

      freetype.dev
      freetype.out

      # PHP extension dependencies
      oniguruma.dev
      oniguruma.lib
      oniguruma.out

      libzip.dev
      libzip.out

      libsodium.dev
      libsodium.out

      php84Extensions.igbinary.dev
      php84Extensions.igbinary.out

      postgresql.dev
      postgresql.lib
      postgresql.out

      mariadb

      openldap.dev
      openldap.out

      libxslt.bin
      libxslt.dev
      libxslt.out

      libargon2

      html-tidy

      enchant2.dev
      enchant2.out

      # Redis/Memcached support
      hiredis

      libmemcached

      # ImageMagick for image processing
      imagemagick.out
      imagemagick.dev
    ];
  };
in

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
        ls = "eza -lamuUh --git --git-repos --octal-permissions --color-scale --color-scale-mode gradient --classify=always";
        update = "sudo nix-channel --update && sudo nix flake update --flake /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos && mise upgrade && mise prune && ghcup install ghc latest && ghcup install cabal latest && ghcup install stack latest && ghcup install hls latest && ghcup set ghc latest && ghcup set cabal latest && ghcup set stack latest && ghcup set hls latest";
        prune = "ghcup gc --unset && nix-env --delete-generations old && sudo nix-store --gc && nix-collect-garbage -d && sudo nix-collect-garbage -d";
        commit_update = "cd ~/src/nix-src && git add * && git commit -m \"$(openssl dgst -sha256 -binary < /etc/nixos/flake.lock | base100)\"";
      };

      sessionVariables = {
        EDITOR = "hx";
        MISE_NODE_COREPACK = "true";
        
        # Build flags
        CFLAGS = "-O2 -g -I${devLibs}/include";
        CXXFLAGS = "-O2 -g -I${devLibs}/include";
        PYTHON_CFLAGS = "-I${devLibs}/include";
        CPPFLAGS = "-I${devLibs}/include";
        LDFLAGS = "-L${devLibs}/lib";
        LD_LIBRARY_PATH = "${devLibs}/lib:${pkgs.stdenv.cc.cc.lib}/lib";
        PKG_CONFIG_PATH = "${devLibs}/lib/pkgconfig:${devLibs}/share/pkgconfig";
        
        # Nix build environment
        NIX_CFLAGS_COMPILE = "-I${devLibs}/include";
        NIX_LDFLAGS = "-L${devLibs}/lib";
        
        # CMake configuration
        CMAKE_PREFIX_PATH = "${devLibs}";
        CMAKE_INCLUDE_PATH = "${devLibs}/include";
        CMAKE_LIBRARY_PATH = "${devLibs}/lib";
        
        # Python/mise configuration
        PYTHON_CONFIGURE_OPTS = "--with-openssl=${devLibs}";
        
        # Erlang/Elixir configuration
        KERL_CONFIGURE_OPTIONS = "--enable-wx --enable-webview --with-ssl=${devLibs} --with-odbc=${devLibs}";
        
        # PHP configuration
        PHP_CONFIGURE_OPTIONS = "--with-openssl=${devLibs} --with-curl=${devLibs} --with-gettext=${devLibs} --with-sodium=${devLibs}";
        
        # Ruby configuration (skip test extensions to avoid NixOS glibc compatibility issues)
        RUBY_CONFIGURE_OPTS = "--disable-install-doc --with-out-ext=-test-/cxxanyargs";
        
        # Clang/LLVM library paths
        ZLIB_ROOT = "${devLibs}";
        ZLIB_LIBRARY = "${devLibs}/lib/libz.so";
        ZLIB_INCLUDE_DIR = "${devLibs}/include";
        OPENSSL_ROOT = "${devLibs}";
        OPENSSL_LIBRARIES = "${devLibs}/lib";
        OPENSSL_INCLUDE_DIR = "${devLibs}/include";
        LIBXML2_ROOT = "${devLibs}";
        LIBXML2_LIBRARIES = "${devLibs}/lib";
        LIBXML2_INCLUDE_DIR = "${devLibs}/include";
        Backtrace_ROOT = "${pkgs.libbacktrace}";
        Backtrace_LIBRARIES = "${pkgs.libbacktrace}/lib";
        Backtrace_INCLUDE_DIR = "${pkgs.libbacktrace}/include";
        LIBEDIT_ROOT = "${devLibs}";
        LIBEDIT_LIBRARIES = "${devLibs}/lib";
        LIBEDIT_INCLUDE_DIR = "${devLibs}/include";
        
        # Rust linker configuration
        RUSTFLAGS = "-L ${devLibs}/lib -L ${pkgs.stdenv.cc.cc.lib}/lib -C link-arg=-Wl,-rpath,${devLibs}/lib -C link-arg=-Wl,-rpath,${pkgs.stdenv.cc.cc.lib}/lib";
      };

    packages = with pkgs; [
      (pkgs.callPackage ./download.nix { })
      
      # Add devLibs to packages so it's in the environment
      devLibs

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

      # build-essential tools
      (lib.hiPrio clang)
      gcc
      cmake
      ninja
      gnumake
      automake
      autoconf
      autogen
      libtool
      pkg-config
      binutils
      gdb
      patch
      m4
      flex
      
      # libraries
      rlwrap
      bc
      mesa
      (wxGTK32.override { withWebKit = true; })
      wxc
      #llvmPackages.clangWithLibcAndBasicRtAndLibcxx
      go
      darcs
      gh # GitHub CLI
      helix
      micro
      emacs
      mercurialFull
      bubblewrap

      nixd
      nil
    ];
    stateVersion = "25.05";
  };

  programs = {
    
    bash = {
      enable = true;
      # ... other things here
      initExtra = ''
        # Ensure development environment is available in all bash sessions
        if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fi
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
          "cargo:speedo" = "latest";
          "cargo:ascim" = "latest";
          "npm:npm" = "latest";
          "npm:cordova" = "latest";
          "npm:corepack" = "latest";
          "npm:@quasar/cli" = "latest";
          "npm:@google/gemini-cli" = "latest";
          "npm:@github/copilot" = "latest";
          cargo-binstall = "latest";
          bun = "latest";
          deno = "latest";
          elixir = "latest";
          erlang = "latest";
          ghcup = "latest";
          go = "latest";
          java = "oracle-graalvm";
          flutter = "latest";
          php = "latest";
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
