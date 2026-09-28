---
name: radon-deploy
description: Use when deploying or rebuilding the NixOS radon host at 192.168.1.87.
---

# Radon Deployment

Use the following command for deployments to `radon`:

```bash
NIX_SSHOPTS='-o IdentitiesOnly=yes -i /home/shahvirb/.ssh/homelab-primary' \
nixos-rebuild switch \
  --flake /etc/nixos#radon \
  --build-host localhost \
  --target-host shahvirb@192.168.1.87 \
  --sudo \
  --ask-sudo-password \
  --impure
```

The target address is `192.168.1.87`.

## Audit Before Deployment

The audit begins with a remote `dry-activate` against the target host. It compares the proposed system with the active generation without applying changes. The resulting differences are reviewed for unexpected activation or runtime impacts.
