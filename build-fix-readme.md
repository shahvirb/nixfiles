# Host Migration Guide

After the flake was converted to multi-host (no more `systemSettings.nix` symlink), each host needs these steps to pick up the changes.

## Per-host procedure

### 1. Pull latest changes

```
cd /etc/nixos && git pull
```

### 2. Remove the old root symlink

```
rm /etc/nixos/systemSettings.nix
```

This was a local-only symlink pointing to `hosts/<hostname>/systemSettings.nix`. It was never git-tracked. The new flake reads `hosts/*/systemSettings.nix` directly — the symlink is no longer needed.

### 3. Rebuild

First time uses the full command (the new `nrbs` alias won't work until after the switch):

```
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --impure
```

After the switch, the new aliases take effect:

| Alias | Command |
|-------|---------|
| `nrbs` | `sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --impure` |
| `nrbb` | `sudo nixos-rebuild boot --flake /etc/nixos#$(hostname) --impure` |
| `nrbsu` | `sudo nix flake update && sudo nixos-rebuild boot --flake /etc/nixos#$(hostname) --impure` |
| `nfu` | `nix flake update` |

Reload bash if the alias doesn't appear: `source ~/.bashrc`

## Host-specific notes

| Host | Profile | Notes |
|------|---------|-------|
| mediaserver2 | lxc | Already migrated |
| argon | lxc | Should build cleanly |
| kasm | lxc | Should build cleanly |
| thinkpadX1 | graphical | May hit pnpm insecure package error (see below) |
| desktop-algonquin | graphical | Will fail on pnpm insecure until fixed (see below) |

## Graphical host fix — insecure pnpm package

Graphical hosts pull in `pnpm-10.29.2` which is marked insecure. Add this to the host's `configuration.nix`:

```nix
nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];
```

## pipx test failure

If a host uses `home-manager/python.nix` (or has `pipx` in its packages), nixpkgs-stable still ships pipx 1.8.0 with broken tests (see [nixpkgs#522307](https://github.com/NixOS/nixpkgs/issues/522307)). The fix is to override it:

```nix
(pipx.overridePythonAttrs (_: { doCheck = false; }))
```

This is already applied in `home-manager/python.nix` — hosts importing that module are covered.
