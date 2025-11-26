{ config, pkgs, lib, ... }:

let
  devLibs = import ./dev-libs.nix { inherit pkgs; };
  scriptDir = ../scripts;
  scriptFiles = builtins.attrNames (builtins.readDir scriptDir);
  nixScripts = builtins.filter (name: pkgs.lib.hasSuffix ".nix" name) scriptFiles;
  scripts = map (name: pkgs.callPackage (scriptDir + "/${name}") { }) nixScripts;
in
scripts ++ (with pkgs; [

  # Add devLibs to packages so it's in the environment
  devLibs

  # Zed editor from flake
  # zed-editor.packages.${pkgs.stdenv.hostPlatform.system}.default

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
  eza # A modern replacement for 'ls'
  fzf # A command-line fuzzy finder
  pv # Pipe Viewer - monitor data progress through pipelines

  # networking tools
  mtr # A network diagnostic tool
  iperf3
  dnsutils  # `dig` + `nslookup`
  ldns # replacement of `dig`, it provide the command `drill`
  aria2 # A lightweight multi-protocol & multi-source command-line download utility
  socat # replacement of openbsd-netcat
  nmap # A utility for network discovery and security auditing
  ipcalc  # it is a calculator for the IPv4/v6 addresses

  # media tools
  yt-dlp # YouTube downloader
  ffmpeg # Video/audio processing

  # misc
  cowsay
  file
  which
  tree
  gnused
  gnutar
  gawk
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
])
