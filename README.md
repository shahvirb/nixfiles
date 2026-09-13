# Bootstrapping this repo

New machines are bootstrapped from a complete, machine-specific bundle. Create the
bundle on a trusted machine that has access to the 1Password vault, then transfer it
securely to the new machine. The bundle contains the flake, the selected host
configuration, and the generated files that are normally excluded from Git.

## Create a machine bundle

1. Create or update `hosts/<machine-name>/` with these files:
   - `systemSettings.nix`
   - `configuration.nix`
   - `home.nix`

   The directory name and `systemSettings.hostname` must match the machine name.
2. From `/etc/nixos`, generate the ignored files from their 1Password templates:

   ```bash
   ./op-unpack.sh
   ```

   The script creates the secret-bearing files required by the configuration.

3. Create an archive that includes the repository files and generated files, but
   not the Git metadata:

   ```bash
   tar --exclude=.git -czf ../<machine-name>-nixos.tar.gz .
   ```

   The archive contains secrets. Protect it during transfer and delete it when it
   is no longer needed.

## Install a machine bundle

From the fresh NixOS machine:

1. Ensure networking is working and that the installed Nix supports flakes.
2. Transfer the matching bundle to the machine.
3. Extract it into `/etc/nixos`, replacing the installer-generated configuration:

   ```bash
   sudo tar -xzf <machine-name>-nixos.tar.gz -C /etc/nixos
   ```

4. Apply the bundled configuration:

   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --impure
   ```

   If the machine hostname does not yet match the host directory, use the host
   name explicitly instead of `$(hostname)`:

   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#<machine-name> --impure
   ```

The rebuild activates the selected host configuration and creates a NixOS
generation. Keep the generated files on the machine if the configuration imports
them; they are ignored by Git and are not recreated by `nixos-rebuild`.

# Command Cheat Sheet

| Description | Command |
|-------------|---------|
| Rebuild and switch | ```sudo nixos-rebuild switch --flake path:.```|
| Flake update | ```sudo nix flake update``` |
| See the value of an option and how it's being set | ```nixos-option networking.hostName``` |
| [Using the Nix repl to see options and values](https://jorel.dev/NixOS4Noobs/options.html#method-3-using-the-nix-repl) | ```nix repl path:.``` |

## Cleaning up old generations
Delete generations older than 2 days: ```sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 2d```. Can also be run with ```--dry-run```

List generations: ```nix profile history --profile /nix/var/nix/profiles/system```

# NixOS LXC in Proxmox

## LXC Creation
Based on:
- https://www.jacob-swanson.com/tech/2023/09/19/nixos-proxmox-lxc-setup.html
- https://nixos.wiki/wiki/Proxmox_Virtual_Environment

1. Download a build here https://hydra.nixos.org/job/nixos/release-23.11/nixos.proxmoxLXC.x86_64-linux
2. Create a CT but don't start it
	1. Ensure an SSH key has been input because password based SSH authentication will not work
3. Options -> features -> Enable nesting
4. Set console mode to "console"
5. Set ipv4 networking option to use a DHCP address
6. Start it

### After first boot
1. ```nix-channel --update``` then reboot
2. <mark style="background: #ff6666">DO NOT create a hardware-configuration.nix file!</mark> This is not needed.
3. Read https://nixos.wiki/wiki/Proxmox_Virtual_Environment for a basic configuration.nix file

## iGPU Passthrough
Read the tteck helper script, in particular this block:

CT_TYPE is 0 for a privileged container, and 1 for unprivileged. Do ```ls /dev/d*``` to see what devices exist. Copy the relevant lines below into your LXC CT .conf file found in ```/etc/pve/lxc```.

```bash

  if [ "$CT_TYPE" == "0" ]; then
    if [[ "$APP" == "Channels" || "$APP" == "Emby" || "$APP" == "Frigate" || "$APP" == "Jellyfin" || "$APP" == "Plex" || "$APP" == "Scrypted" || "$APP" == "Tdarr" || "$APP" == "Unmanic" ]]; then
      cat <<EOF >>$LXC_CONFIG
# VAAPI hardware transcoding
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.cgroup2.devices.allow: c 29:0 rwm
lxc.mount.entry: /dev/fb0 dev/fb0 none bind,optional,create=file
lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
EOF
    fi
  else
    if [[ "$APP" == "Channels" || "$APP" == "Emby" || "$APP" == "Frigate" || "$APP" == "Jellyfin" || "$APP" == "Plex" || "$APP" == "Scrypted" || "$APP" == "Tdarr" || "$APP" == "Unmanic" ]]; then
      if [[ -e "/dev/dri/renderD128" ]]; then
        if [[ -e "/dev/dri/card0" ]]; then
          cat <<EOF >>$LXC_CONFIG
# VAAPI hardware transcoding
dev0: /dev/dri/card0,gid=44
dev1: /dev/dri/renderD128,gid=104
EOF
        else
          cat <<EOF >>$LXC_CONFIG
# VAAPI hardware transcoding
dev0: /dev/dri/card1,gid=44
dev1: /dev/dri/renderD128,gid=104
EOF
        fi
      fi
    fi
  fi
```
