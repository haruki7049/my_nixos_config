{ pkgs, ... }:

{
  services.nix-daemon.enable = true;

  system.stateVersion = 5;
}
