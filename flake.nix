{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    nix-darwin.url = "github:LnL7/nix-darwin";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      userhome-configs = ./src/home;
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
            inherit userhome-configs;
          };
        };
        nixosConfigurations = {
          tuf-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/tuf-chan/configuration.nix;
            inherit userhome-configs;
          };
          pana-chama = x86_64-linux-pc {
            systemConfiguration = ./src/systems/pana-chama/configuration.nix;
            inherit userhome-configs;
          };
          spectre-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/spectre-chan/configuration.nix;
            inherit userhome-configs;
          };
          latitude-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/latitude-chan/configuration.nix;
            inherit userhome-configs;
          };
          the-hp = x86_64-linux-pc {
            systemConfiguration = ./src/systems/the-hp/configuration.nix;
            inherit userhome-configs;
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
