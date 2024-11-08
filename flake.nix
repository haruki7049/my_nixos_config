{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    home-manager.url = "github:nix-community/home-manager";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit
        (import ./system-builder.nix {
          inherit inputs;
        })
        x86_64-linux-pc
        aarch64-darwin-pc
        ;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations = {
          enmac = aarch64-darwin-pc {
            systemConfiguration = ./src/systems/enmac/configuration.nix;
          };
        };
        nixosConfigurations = {
          tuf-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/tuf-chan/configuration.nix;
            userhome-configs = {
              haruki = ./src/home/linux/users/haruki.nix;
              root = ./src/home/linux/users/root.nix;
            };
          };
          pana-chama = x86_64-linux-pc {
            systemConfiguration = ./src/systems/pana-chama/configuration.nix;
            userhome-configs = {
              haruki = ./src/home/linux/users/haruki.nix;
              root = ./src/home/linux/users/root.nix;
            };
          };
          spectre-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/spectre-chan/configuration.nix;
            userhome-configs = {
              haruki = ./src/home/linux/users/haruki.nix;
              root = ./src/home/linux/users/root.nix;
            };
          };
          latitude-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/latitude-chan/configuration.nix;
            userhome-configs = {
              haruki = ./src/home/linux/users/haruki.nix;
              root = ./src/home/linux/users/root.nix;
            };
          };
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.taplo.enable = true;
            programs.stylua.enable = true;
            programs.actionlint.enable = true;
            settings.formatter = {
              "stylua".options = [
                "--indent-type"
                "Spaces"
              ];
            };
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.lua-language-server
              pkgs.nil
              pkgs.sops
            ];
          };
        };
    };
}
