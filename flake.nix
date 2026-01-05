{
  description = "My Neovim Configuration with Lazy.nvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Simple approach: use the neovim package directly
        myNeovim = pkgs.neovim.override {
          configure = {
            customRC = ''
              " Set up basic options
              set number relativenumber
              let g:mapleader = " "
              let g:maplocalleader = " "
              
              " Add our config directory to runtimepath
              set rtp+=${./nvim}
              
              " Source the main configuration
              lua << EOF
              require("config.options")
              require("config.keymaps")
              require("config.lazy")
              EOF
            '';
          };
        };

      in
      {
        packages = {
          default = myNeovim;
          neovim = myNeovim;
        };

        apps = {
          default = {
            type = "app";
            program = "${myNeovim}/bin/nvim";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            myNeovim
            
            # Development tools and LSPs that your config uses
            git
            curl  # For lazy.nvim plugin downloads
            
            # LSP servers (based on your mason config)
            lua-language-server
            nodePackages.typescript-language-server
            pyright
            
            # Additional useful tools
            nil  # Nix LSP
            rust-analyzer
            gopls
            ripgrep  # For telescope
            fd       # For telescope
          ];
          
          shellHook = ''
            echo "Neovim development environment loaded!"
            echo "Run 'nvim' to start neovim with your configuration"
            echo "Plugins will be managed by lazy.nvim as usual"
          '';
        };

        # Home Manager module
        homeManagerModules.default = { config, lib, pkgs, ... }: {
          options.programs.my-neovim = {
            enable = lib.mkEnableOption "my custom neovim configuration";
          };

          config = lib.mkIf config.programs.my-neovim.enable {
            home.packages = [ myNeovim ];
            
            # Optional: Set up shell aliases
            programs.bash.shellAliases.nvim = "${myNeovim}/bin/nvim";
            programs.zsh.shellAliases.nvim = "${myNeovim}/bin/nvim";
            programs.fish.shellAliases.nvim = "${myNeovim}/bin/nvim";
          };
        };
      });
}