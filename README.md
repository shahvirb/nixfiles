# Command Cheat Sheet
Rebuild and switch now: ```sudo nixos-rebuild switch```

Upgrade packages and switch: ```sudo nixos-rebuild switch --upgrade```

## Cleaning up old generations
Delete generations older than 2 days: ```sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 2d```. Can also be run with ```--dry-run```

List generations: ```nix profile history --profile /nix/var/nix/profiles/system```