---
name: radon-deploy
description: Use when deploying or rebuilding the NixOS radon host at 192.168.1.74.
---

# Radon Deployment

Use the following command for deployments to `radon`:

```bash
NIX_SSHOPTS='-o IdentitiesOnly=yes -i /home/shahvirb/.ssh/homelab-primary' \
nixos-rebuild switch \
  --flake /etc/nixos#radon \
  --build-host localhost \
  --target-host shahvirb@192.168.1.74 \
  --sudo \
  --ask-sudo-password \
  --impure
```

The target address is `192.168.1.74`.

## Audit Before Deployment

The audit begins with a remote `dry-activate` against the target host. It compares the proposed system with the active generation without applying changes. The resulting differences are reviewed for unexpected activation or runtime impacts.

## SSH Debugging
`ssh -o IdentitiesOnly=yes -i ~/.ssh/homelab-primary shahvirb@192.168.1.74`

## First Time Bootstrapping
1. Use remote deployment to initially set up the `radon` host.
2. Continue with the following steps on the host machine.
3. `git pull shahvirb/nixfiles`
4. Use `nh os switch --impure`. If `nh` is not available yet, bootstrap it
   with `sudo nixos-rebuild switch --flake /etc/nixos#radon --impure`, then
   start a new login shell and retry `nh os switch --impure`.
5. Do `op signin` to authenticate with your 1Password account.
6. `op-unpack.sh` && `nh os switch --impure`
7. Reboot
