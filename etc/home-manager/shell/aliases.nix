{ ... }:

{
  vi = "hx";
  vim = "hx";
  nano = "hx";
  ls = "eza -lamuUh --git --git-repos --octal-permissions --classify=always";
  update = ''
    sudo nix-channel --update && \
    sudo nix flake update --flake /etc/nixos && \
    sudo nixos-rebuild switch --flake /etc/nixos -v -v && \
    sudo nix-store --optimise && \
    mise upgrade && \
    mise prune
  '';
  prune = ''
    ghcup gc --unset && \
    nix-env --delete-generations old && \
    sudo nix-store --gc && \
    nix-collect-garbage -d && \
    sudo nix-collect-garbage -d && \
    mise-clear && \
    mise upgrade
  '';
  commit_update = "cd ~/src/nix-src && git add * && git commit -m \"$(openssl dgst -sha256 -binary < /etc/nixos/flake.lock | base-d -e base100)\"";
}
