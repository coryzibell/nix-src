{ ... }:

{
  enable = true;
  initExtra = ''
    # Ensure development environment is available in all bash sessions
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi
  '';
}
