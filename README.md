# Neovim Nix Flake Configuration

A reproducible Neovim configuration using Nix flakes that preserves your existing lazy.nvim setup.

## Structure

```
neovim-config/
├── flake.nix           # Main flake definition
├── flake.lock          # Lock file (generated)
├── nvim/               # Your neovim configuration
│   ├── init.lua        # Entry point
│   ├── lazy-lock.json  # Lazy.nvim plugin versions
│   └── lua/
│       ├── config/     # Core configuration
│       │   ├── keymaps.lua
│       │   ├── lazy.lua
│       │   └── options.lua
│       └── plugins/    # Plugin configurations
│           ├── completion.lua
│           ├── lsp.lua
│           ├── ui.lua
│           └── ...
└── README.md           # This file
```

## Installation

### Quick Install (System-wide)
```bash
# Install directly from GitHub
nix profile install github:yourusername/neovim-config

# Or use the install script
curl -sSL https://raw.githubusercontent.com/yourusername/neovim-config/main/install.sh | bash
```

## Usage

### Run Neovim directly (without installing)
```bash
nix run github:yourusername/neovim-config
```

### Enter development shell
```bash
nix develop
nvim  # Neovim with your config + all LSPs/tools
```

### Build the package
```bash
nix build
./result/bin/nvim
```

### Home Manager Integration

Add to your home.nix:
```nix
{
  inputs.my-neovim.url = "github:yourusername/neovim-config";
  
  # In your home configuration:
  imports = [ inputs.my-neovim.homeManagerModules.default ];
  
  programs.my-neovim.enable = true;
}
```

## Features

- **Preserves your existing config**: Uses your current nvim configuration with lazy.nvim
- **Reproducible**: Same setup across all machines
- **LSP Integration**: Includes all LSPs from your mason config (lua_ls, ts_ls, pyright)
- **Development Tools**: Includes ripgrep, fd, git, curl for full functionality
- **Isolated**: Uses `NVIM_APPNAME=nvim-nix` to avoid conflicts

## How It Works

1. Your nvim config is copied to the nix store
2. Neovim is configured to load from that path
3. Lazy.nvim manages plugins as usual (downloading at runtime)
4. LSP servers and tools are provided by nix in the development shell
5. Configuration remains fully functional and portable

## Plugin Management

This setup uses a **hybrid approach**:
- **Core dependencies** (like plenary.nvim) via nix for reliability
- **Most plugins** via lazy.nvim for flexibility and your existing workflow
- **LSP servers** via nix for consistent versions across environments

## Development

Your existing lazy.nvim workflow remains unchanged:
- Add plugins in `lua/plugins/`
- Configure in your usual lazy.nvim format
- Run `:Lazy` commands as normal
- Plugins are downloaded to the standard lazy.nvim directory

## Customization

### Adding More LSPs
Edit the `devShells.default.buildInputs` in `flake.nix`:
```nix
buildInputs = with pkgs; [
  # ... existing tools
  haskell-language-server
  clang-tools  # for C/C++
  # etc.
];
```

### Different Neovim Version
Change `pkgs.neovim-unwrapped` to:
- `pkgs.neovim-nightly` (requires overlay)
- Specific version via nixpkgs pin

## Troubleshooting

**Plugins not loading**: Ensure lazy.nvim can download plugins (internet connection, git available)

**LSP not working**: Check that the LSP is included in the development shell buildInputs

**Config conflicts**: The `NVIM_APPNAME=nvim-nix` should isolate this from your main config

**Updates**: Run `nix flake update` to update nixpkgs and rebuild
