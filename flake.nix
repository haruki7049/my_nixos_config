{
  description = "My NixOS's configuration for haruki7049";

  inputs.nixos.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixos }: {
    # "nixos-rebuild switch --flake .#tuf-chan"
    nixosConfigurations = {
      tuf-chan = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./src/tuf-chan/configuration.nix ];
      };
      pana-chama = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./src/pana-chama/configuration.nix ];
      };
      haruki7049-home = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./src/haruki7049-home/configuration.nix ];
      };
    };
  };
}
