# den 2.0 Deployment Guide

This guide covers deploying NixOS to the new Hetzner dedicated server (den 2.0) using nixos-anywhere.

## Server Specs
- **Hostname:** den (den-2.0)
- **CPU:** AMD Ryzen 9 7950X3D (16 cores, 32 threads)
- **RAM:** 128GB DDR5
- **Storage:** 2x 1.92TB NVMe (ZFS mirror)
- **Location:** Helsinki, Finland

## Prerequisites

### On Your Local Machine

1. **Install nixos-anywhere:**
   ```bash
   nix-shell -p nixos-anywhere
   # OR if you have nix flakes enabled:
   nix run github:nix-community/nixos-anywhere -- --help
   ```

2. **Ensure SSH access:**
   - You should have SSH access to the server's rescue system
   - Server is typically booted into Hetzner's rescue system initially

3. **Add your SSH public key:**
   - Edit `hosts/den/configuration.nix`
   - Add your SSH public key to `users.users.kautau.openssh.authorizedKeys.keys`
   - Example:
     ```nix
     openssh.authorizedKeys.keys = [
       "ssh-ed25519 AAAAC3... your-key-comment"
     ];
     ```

## Pre-Deployment Checklist

- [ ] Branch `den-2.0` is checked out
- [ ] Your SSH public key is added to `hosts/den/configuration.nix`
- [ ] You have SSH access to the server's rescue system
- [ ] You've verified the disk device names (should be `/dev/nvme0n1` and `/dev/nvme1n1`)
- [ ] (Optional) Run `nix flake check` locally to validate configuration

## Deployment Steps

### 1. Validate the Flake

From the nix-src repository root:

```bash
cd ~/forge/nix-src
nix flake check --show-trace
```

This will validate the syntax and structure of all configurations.

### 2. Boot Server into Rescue System

If not already done:
- Log into Hetzner Robot
- Activate rescue system for the server
- Reboot the server
- SSH into the rescue system

### 3. Verify Disk Layout

SSH into the rescue system and check disk names:

```bash
ssh root@<server-ip>
lsblk
# Should show /dev/nvme0n1 and /dev/nvme1n1
```

If disk names are different, update `hosts/den/disk-config.nix` accordingly.

### 4. Deploy with nixos-anywhere

From your local machine (in the nix-src directory):

```bash
# Using nix-shell
nix-shell -p nixos-anywhere --run "nixos-anywhere --flake .#den root@<server-ip>"

# OR using nix run (if you have flakes enabled)
nix run github:nix-community/nixos-anywhere -- --flake .#den root@<server-ip>
```

**What this does:**
1. Connects to the server via SSH
2. Partitions and formats the disks according to `disk-config.nix`
3. Creates ZFS mirror pool across both NVMe drives
4. Installs NixOS with the configuration
5. Reboots into the new system

**This will take 15-30 minutes.** The process:
- Partitions disks (destructive!)
- Creates ZFS pool
- Downloads and installs NixOS
- Applies configuration
- Reboots

### 5. Post-Deployment

After the server reboots:

```bash
# SSH into the new system (as kautau, not root)
ssh kautau@<server-ip>

# Verify ZFS pool
sudo zpool status

# Check system
nixos-version
systemctl status

# Test Docker
docker run hello-world
```

## Configuration Overview

### Disk Layout (ZFS Mirror)

```
/dev/nvme0n1
├── /dev/nvme0n1p1  → /boot (1GB, FAT32)
└── /dev/nvme0n1p2  → rpool (ZFS, mirrored)

/dev/nvme1n1
├── /dev/nvme1n1p1  → (unused, backup boot)
└── /dev/nvme1n1p2  → rpool (ZFS, mirrored)

rpool (ZFS mirror)
├── rpool/root     → /           (ephemeral, wiped on boot)
├── rpool/nix      → /nix        (persistent)
├── rpool/home     → /home       (persistent)
├── rpool/persist  → /persist    (persistent)
└── rpool/docker   → /var/lib/docker (persistent)
```

### Key Features

- **ZFS mirror** across both NVMe drives for redundancy
- **Automatic snapshots** (hourly, daily, weekly, monthly)
- **Monthly scrubs** for data integrity
- **Docker** with ZFS backend
- **SSH** hardened (key-only, no root login)
- **Fail2ban** for SSH protection
- **Home Manager** for user environment
- **mise** for tool version management

## Troubleshooting

### nixos-anywhere fails with disk errors

Check disk names in rescue system:
```bash
ssh root@<server-ip>
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```

Update `hosts/den/disk-config.nix` if names differ.

### SSH connection refused after deployment

- Wait 2-3 minutes after reboot for services to start
- Check if you added your SSH public key to configuration
- Verify firewall allows port 22 (should be open by default)

### ZFS pool issues

After deployment, check pool health:
```bash
sudo zpool status
sudo zpool list
```

If pool is degraded, check both disks are present:
```bash
lsblk
```

### Home Manager errors

If home-manager fails to activate:
```bash
# SSH into server as kautau
home-manager switch --show-trace
```

## Updating the Configuration

After initial deployment, update the system with:

```bash
# On the server (as kautau)
cd /path/to/nix-src  # Clone the repo if needed
git pull
sudo nixos-rebuild switch --flake .#den
```

Or rebuild locally and push:

```bash
# On local machine
nixos-rebuild switch --flake .#den --target-host kautau@<server-ip> --use-remote-sudo
```

## Important Notes

1. **Destructive Operation:** nixos-anywhere WILL ERASE ALL DATA on the target disks. Only run this on a fresh server.

2. **SSH Keys:** Make sure your SSH public key is in the configuration BEFORE deploying. Otherwise you'll be locked out.

3. **Root Access:** After deployment, root login via SSH is disabled. Only the `kautau` user can SSH in, and must use `sudo` for admin tasks.

4. **ZFS:** The root filesystem (`/`) is ephemeral and reset on boot. Only `/nix`, `/home`, `/persist`, and `/var/lib/docker` survive reboots. This is intentional for a clean system state.

5. **Hetzner-specific:** After successful deployment, you can disable the rescue system in Hetzner Robot.

## Next Steps

After deployment:

1. Clone your repositories to the new server
2. Set up any additional services
3. Configure Docker containers
4. Set up automated backups (ZFS snapshots are local only)
5. Update DNS records to point to new server IP

---

**The Tsunderground lives here now.**

*Everything is fine. The clipboard is on fire. This is normal.*
