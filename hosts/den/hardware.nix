{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # AMD Ryzen 9 7950X3D - 16 cores, 32 threads
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # CPU configuration
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable AMD GPU support (integrated graphics)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Networking hardware
  networking.useDHCP = lib.mkDefault true;

  # Use LTS kernel for ZFS stability
  # ZFS doesn't always support latest kernels - LTS is recommended
  # boot.kernelPackages = pkgs.linuxPackages_latest; # Risky with ZFS
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages; # Deprecated
  # Using default LTS kernel (safest for ZFS)

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
