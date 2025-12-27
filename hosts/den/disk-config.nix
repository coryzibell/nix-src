{ lib, ... }:

{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
      nvme1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            boot-mirror = {
              size = "1G";
              type = "EF00";
              # Boot partition is not mirrored - nvme0 is primary
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12"; # Sector size alignment - recommended for modern SSDs
          autotrim = "on"; # Enable TRIM for SSDs
        };
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          # Root filesystem - ephemeral, wiped on boot
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "/";
            };
            postCreateHook = "zfs snapshot rpool/root@blank";
          };

          # Nix store - persistent
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "/nix";
              atime = "off";
            };
          };

          # Home directories - persistent
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "/home";
            };
          };

          # Persistent data
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              mountpoint = "/persist";
            };
          };

          # Docker volumes
          docker = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
            options = {
              mountpoint = "/var/lib/docker";
            };
          };
        };
      };
    };
  };
}
