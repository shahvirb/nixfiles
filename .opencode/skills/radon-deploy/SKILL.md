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
  --impure
```

The target address is `192.168.1.87`. Do not use the older `192.168.1.85` address.

## Bootstrap

```bash
ssh -tt -o IdentitiesOnly=yes \
  -i /home/shahvirb/.ssh/homelab-primary \
  shahvirb@192.168.1.87
```

```bash
sudo systemctl edit --runtime nix-daemon.service
```

```ini
[Service]
Environment="NIX_CONFIG=trusted-users = root shahvirb"
```

```bash
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon.service
```
