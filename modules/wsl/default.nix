{ config, pkgs, lib, ... }:

{
  # WSL-specific configuration for Windows machines
  # This preserves the existing WSL setup from etc/configuration.nix

  wsl = {
    enable = true;
    defaultUser = "kautau";
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
      { src = "${coreutils}/bin/dirname"; }
      { src = "${coreutils}/bin/readlink"; }
      { src = "${curl}/bin/curl"; }
    ];
  };

  # Docker on WSL
  virtualisation.docker.enable = true;

  # Basic system packages for WSL
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    nushell
    zsh
  ];
}
