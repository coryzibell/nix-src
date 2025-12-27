{ config, pkgs, lib, ... }:

{
  # Server-specific configuration

  # SSH hardening
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = lib.mkDefault false;
      KbdInteractiveAuthentication = lib.mkDefault false;
      X11Forwarding = lib.mkDefault false;
    };
  };

  # Firewall - enable by default on servers
  networking.firewall.enable = lib.mkDefault true;

  # Automatic updates and maintenance
  system.autoUpgrade = {
    enable = false; # Manual control for now
    allowReboot = false;
  };

  # Disable unnecessary services for headless servers
  services.xserver.enable = lib.mkDefault false;
  sound.enable = lib.mkDefault false;

  # Security hardening
  security = {
    sudo = {
      wheelNeedsPassword = lib.mkDefault true;
      execWheelOnly = true;
    };
  };
}
