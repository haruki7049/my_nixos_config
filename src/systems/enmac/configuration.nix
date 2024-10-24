{ pkgs, ... }:

{
  services.nix-daemon.enable = true;

  programs = {
    bash.enable = true;
    zsh.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  system.stateVersion = 5;
}
