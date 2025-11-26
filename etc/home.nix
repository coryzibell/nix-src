{ config, pkgs, lib, zed-editor, mise, ... }:

{
  home = {
    username = "kautau";
    homeDirectory = "/home/kautau";
    sessionPath = [
      "/home/kautau/.ghcup/bin"
    ];

    shellAliases = import ./home-manager/shell/aliases.nix { };
    sessionVariables = import ./home-manager/shell/environment.nix { inherit pkgs; };
    packages = import ./home-manager/packages { inherit config pkgs lib; };

    stateVersion = "25.05";
  };

  programs = {
    bash = import ./home-manager/programs/bash.nix { };
    zsh = import ./home-manager/programs/zsh.nix { };
    git = import ./home-manager/programs/git.nix { };
    mise = import ./home-manager/programs/mise.nix { inherit pkgs mise; };
    nushell = import ./home-manager/programs/nushell.nix { };
    carapace = import ./home-manager/programs/carapace.nix { };
    starship = import ./home-manager/programs/starship.nix { };
    home-manager = import ./home-manager/programs/home-manager.nix { };
  };
}
