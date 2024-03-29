# Command Cheat Sheet
```sudo nixos-rebuild switch```

## Cleaning up old generations
```sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 2d``` to delete older than N days.

```nix profile history --profile /nix/var/nix/profiles/system``` to list generations.