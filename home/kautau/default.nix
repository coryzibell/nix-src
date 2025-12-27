{ config, pkgs, lib, mise, ... }:

{
  home = {
    username = "kautau";
    homeDirectory = "/home/kautau";
    sessionPath = [
      "/home/kautau/.ghcup/bin"
    ];

    shellAliases = import ./shell/aliases.nix { };
    sessionVariables = import ./shell/environment.nix { inherit pkgs; };
    packages = import ./packages { inherit config pkgs lib; };

    stateVersion = "25.05";
  };

  programs = {
    bash = import ./programs/bash.nix { };
    zsh = import ./programs/zsh.nix { };
    git = import ./programs/git.nix { };
    mise = import ./programs/mise.nix { inherit pkgs mise; };
    nushell = import ./programs/nushell.nix { };
    carapace = import ./programs/carapace.nix { };
    starship = import ./programs/starship.nix { };
    home-manager = import ./programs/home-manager.nix { };
  };
}
