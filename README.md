# Bootstrapping this repo
From a fresh or existing NixOS install:
1. ```sudo chown -R $USER /etc/nixos``` because I assume that this repo is cloned directly into /etc/nixos
2. ```nix-shell -p git git-credential-oauth vscode``` 
3. Clone this repo [into /etc/nixos](https://www.devgem.io/posts/how-to-clone-a-git-repository-into-an-existing-folder).
4. Add a ```hosts/<machine-name>``` directory if it doesn't exist.
5. Symlink/copy configuration.nix and hardware-configuration.nix. configuration.nix and hardware-configuration.nix in /etc/nixos should be symlinks to ```hosts/<machine-name>/*.nix``` files
6. Some parts of this repo may require unstable packages:
    ```
    sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    sudo nix-channel --update
    ```
7. Try it. Run ```sudo nixos-rebuild switch```

# Command Cheat Sheet
Rebuild and switch now: ```sudo nixos-rebuild switch```

Upgrade packages and switch: ```sudo nixos-rebuild switch --upgrade```

See the value of an option and how it's being set: ```nixos-option networking.hostName```

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
