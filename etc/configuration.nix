# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# htt ps://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    # <nixos-wsl/modules>
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    vim
    wget
    nushell
    zsh
  ];
  # Set the default editor to vim
  environment.variables.EDITOR = "nano";
  
  users.users.kautau = {
    isNormalUser = true;
    description = "Kautau";
    extraGroups = [ "wheel" "docker" ];
  };

  virtualisation.docker.enable = true;

}
