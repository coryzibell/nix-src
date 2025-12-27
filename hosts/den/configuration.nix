{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./disk-config.nix
    ./services.nix
    ../../modules/common
    ../../modules/server
  ];

  # System identification
  networking.hostName = "den";
  networking.hostId = "8425e349"; # Required for ZFS - random 8 hex digits

  # Timezone and locale
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable ZFS services
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "rpool" ];

  # ZFS auto-scrub
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  # ZFS auto-snapshot
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 4; # Keep 4 15-minute snapshots
    hourly = 24;
    daily = 7;
    weekly = 4;
    monthly = 12;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # User configuration
  users.users.kautau = {
    isNormalUser = true;
    description = "Kautau";
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.zsh;
    # "wake up, thicc girl" - first words to our den
    initialHashedPassword = "$6$nGDcILkTY6nKeXT3$Q5RkkFWbiRHSOQWXjSkJTne465eOhAXZW85gZP8kh5nGZiWsn.eXtBKu2C2weRVwET18kY.15CiRGx4Ydmb220";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjMvfQ4tCUekA6Ug12T1oaB86Z9jgz9Pnov7REhx78h kautau@den"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsLRQ51dnMmZdB4cqptw0VjRArcfVyEc1Jdxmx/op5C tsunderground"
    ];
  };

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = true;

  # System packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
    tmux
    zsh
    nushell
  ];

  # Editor
  environment.variables.EDITOR = "vim";

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this.
  system.stateVersion = "25.05";
}
