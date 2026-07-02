# opencode Guide for this NixOS Homelab Repo

This document provides examples and best practices for using opencode to manage the NixOS and home-manager configurations in this repository.

## How it Works

This repository uses a Nix Flake (`flake.nix`) to manage system configurations. Each machine you want to manage is called a "host" and has its own configuration files located in the `hosts/` directory.

The key files for each host are:
- `hosts/<hostname>/configuration.nix`: The main NixOS system configuration.
- `hosts/<hostname>/home.nix`: The home-manager configuration for your user on that host.
- `hosts/<hostname>/systemSettings.nix`: Host-specific settings like hostname and system architecture.

The flake builds all hosts in parallel. Select a host via the `#hostname` suffix. The `--impure` flag allows access to local-only files (secrets, etc.).

Apply the configuration with:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --impure
```

## Common Tasks with opencode

Here are some examples of how you can use opencode to perform common tasks in this repository.

### 1. Adding a new package

To add a package to your user profile on all machines, you can ask opencode to modify the shared `common.nix` file for home-manager.

**Example Prompt:**
> "Add the `ripgrep` package to the list of common home-manager packages in `home-manager/common.nix`."

If you want to add a package only for a specific host, you can target that host's `home.nix`.

**Example Prompt:**
> "Add the `gparted` package for the user on host `desktop-algonquin`."

### 2. Opening a firewall port

To open a port on a specific host, you need to modify its `configuration.nix`.

**Example Prompt:**
> "On the 'argon' host, open TCP port 3000 for a new service I'm testing."

### 3. Adding a new service

To add a new service, you'll likely need to modify a host's `configuration.nix` to enable it, and potentially open firewall ports.

**Example Prompt:**
> "I want to run a `homepage-dashboard` service on the 'argon' host. Please add the necessary configuration to `hosts/argon/configuration.nix`. It should be available on port 8992."

### 4. Creating a new module

You can ask opencode to create a new module for you. It's a good practice to tell it what the module should do.

**Example Prompt:**
> "Create a new home-manager module named `btop.nix` in the `home-manager` directory. This module should enable and configure the `btop` program."

After the module is created, you will need to import it into the desired `home.nix` file (e.g., `hosts/argon/home.nix`). You can also ask opencode to do this for you.

**Example Prompt:**
> "Now, import the `btop.nix` module you just created into `hosts/argon/home.nix`."

### 5. Adding a new host

To add a new host, you can ask opencode to create a new directory under `hosts/` with the necessary files, using an existing host as a template.

**Example Prompt:**
> "Please create a new directory `hosts/new-machine` for a new NixOS host. Copy the configuration files from `hosts/argon` to this new directory. In the new files, replace all instances of 'argon' with 'new-machine'. Also create a `systemSettings.nix` for an x86_64-linux system."

### 6. Asking Questions

You can ask opencode about the configuration to understand it better.

**Example Prompts:**
> "Which file manages the packages for my user on the 'argon' host?"

> "Where is the Docker service enabled?"

> "What firewall ports are open on the 'mediaserver2' host?"
