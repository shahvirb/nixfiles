# Bootstrapping this repo
From a fresh or existing NixOS install:
1. ```sudo chown -R $USER /etc/nixos``` because I assume that this repo is cloned directly into /etc/nixos
2. ```nix-shell -p git git-credential-oauth vscode``` 
3. Clone this repo [into /etc/nixos](https://www.devgem.io/posts/how-to-clone-a-git-repository-into-an-existing-folder).
4. Add a ```hosts/<machine-name>``` directory if it doesn't exist.
5. Symlink/copy configuration.nix and hardware-configuration.nix. configuration.nix and hardware-configuration.nix in /etc/nixos should be symlinks to ```hosts/<machine-name>/*.nix``` files
6. Try it. Run ```sudo nixos-rebuild switch```


# Command Cheat Sheet
Rebuild and switch now: ```sudo nixos-rebuild switch```

Upgrade packages and switch: ```sudo nixos-rebuild switch --upgrade```

See the value of an option and how it's being set: ```nixos-option networking.hostName```

## Cleaning up old generations
Delete generations older than 2 days: ```sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 2d```. Can also be run with ```--dry-run```

List generations: ```nix profile history --profile /nix/var/nix/profiles/system```