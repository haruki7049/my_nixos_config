{ pkgs, ... }:

{
  services.nix-daemon.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
    };
    casks = [
      "alacritty"
    ];
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.neovim
    pkgs.git
  ];

  fonts = {
    packages = [
      pkgs.udev-gothic-nf
    ];
  };

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
