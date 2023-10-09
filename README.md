# `kickstart-nix.nvim`

A simple [Nix](https://nixos.org/) flake template for Neovim derivations. 

![](https://github.com/mrcjkb/kickstart-nix.nvim/assets/12857160/84faa268-82de-4401-acf3-efddc26dd58a)

## Test drive

If you have Nix installed (with [flakes](https://nixos.wiki/wiki/Flakes) enabled),
you can test drive this by running:

```console
nix run "github:mrcjkb/kickstart-nix.nvim"
```

## Usage

1. Click on [Use this template](https://github.com/mrcjkb/kickstart-nix.nvim/generate)
to start a repo based on this template. **Do _not_ fork it**.
1. Add/remove plugins to/from the [Neovim overlay](./nix/neovim-overlay.nix).
1. Add/remove plugin configs to/from the `nvim/plugin` directory.
1. Modify as you wish (you will probably want to add a color theme, ...).

## Installation

### NixOS (with flakes)

1. Add your flake to you NixOS flake inputs.
1. Add the overlay provided by this flake.

```nix
nixpkgs.overlays = [
    # replace <kickstart-nix-nvim> with the name you chose
    <kickstart-nix-nvim>.overlays.default
];
```

### Non-NixOS

With Nix installed (flakes enabled), from the repo root:

```console
nix profile install .#nvim
```

## Philosophy

- Slightly opinionated defaults.
- Manage plugins + external dependencies using Nix
  (managing plugins shouldn't be the responsibility of a plugin).
- Configuration entirely in Lua[^1] (Vimscript is also possible).
  This makes it easy to migrate from non-nix dotfiles[^2].
- Usable on any device with Neovim and Nix installed.
- Ability to create multiple derivations with different sets of plugins.
- Use either nixpkgs or flake inputs as plugin source.
- Use Neovim's built-in loading mechanisms.
    - See [`:h initializaion`](https://neovim.io/doc/user/starting.html#initialization)
      and [`:h runtimepath`](https://neovim.io/doc/user/options.html#'runtimepath').
- Use Neovim's built-in LSP client.

[^1]: If you were to copy the `nvim` directory to `$XDG_CONFIG_HOME`,
      it would work out of the box.
[^2]: Caveat: `after/` directories are not sourced in the Nix derivation.

## Design

### Neovim configs

- Set options in `init.lua`.
- Source autocommands, user commands, keymaps,
  and configure plugins in individual files within the `plugin` directory.
- Filetype-specific scripts (e.g. start LSP clients) in the `ftplugin` directory.
- Library modules in the `lua/user` directory.

Directory structure:

```console
── nvim
  ├── ftplugin # Sourced when opening a file type
  │  └── <filetype>.lua
  ├── init.lua # Always sourced
  ├── lua # Shared library modules
  │  └── user
  │     └── <lib>.lua
  └── plugin # Automatically sourced at startup
     ├── autocommands.lua
     ├── commands.lua
     ├── keymaps.lua
     ├── plugins.lua # Plugins that require a `setup` call
     └── <plugin-config>.lua # Plugin configurations
```

### Nix

You can declare Neovim derivations in `nix/neovim-overlay.nix`.

There are two ways to add plugins:

- The traditional way, using `nixpkgs` as the source.
- By adding plugins as flake inputs (if you like living on the bleeding-edge).
  Plugins added as flake inputs must be built in `nix/plugin-overlay.nix`.

Directory structure:

```console
── flake.nix
── nix
  ├── mkNeovim.nix # Function for creating the Neovim derivation
  ├── neovim-overlay.nix # Overlay that adds Neovim derivation
  └── plugin-overlay.nix # Overlay that builds flake input plugins
```

## Pre-configured plugins

This configuration comes with [a few plugins pre-configured](./nix/neovim-overlay.nix).

You can add or remove plugins by

- Adding/Removing them in the [Nix list](./nix/neovim-overlay.nix).
- Adding/Removing the config in `nvim/plugin/<plugin>.lua`.

## Alternative / Similar projects

- [`neovim-flake`](https://github.com/jordanisaacs/neovim-flake):
  Configured using a Nix module DSL.
- [`nixvim`](https://github.com/nix-community/nixvim):
  A Neovim distribution configured using a NixOS module.
- [`kickstart.nvim`](https://github.com/nvim-lua/kickstart.nvim):
  Single-file Neovim configuration template.
  Does not use Nix to manage plugins.
