{ config, lib, pkgs, ... }:
{
  imports = [
    ./i3wm/i3.nix
    ./neovim/neovim.nix
    ./vim/vim.nix
  ];
  home.packages = with pkgs; [
    mg
    your-editor
    helix
    bash
    htop
    wget
    curl
    unzip
    gzip
    git
    zellij
    nixpkgs-fmt
    brave
    google-chrome
    neovide
    discord
    element-desktop
    slack
    whalebird
    osu-lazer
    anki
    thunderbird
    spotify
    gns3-gui
    gns3-server
    #ciscoPacketTracer8
  ];
  home.pointerCursor =
    let
      getFrom = url: sha256: name: size: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = size;
        package = pkgs.runCommand "moveUp" { } ''
          mkdir -p $out/share/icons
          ln -s ${
            builtins.fetchTarball {
              url = url;
              sha256 = sha256;
            }
          } $out/share/icons/${name}
        '';
      };
    in
    getFrom
      "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"
      "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=" "bibata" 24;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    bash = { enable = true; };
    nushell = { enable = true; };
    fish = { enable = true; };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };
    alacritty = {
      enable = true;
      settings = {
        font.size = 8.0;
        font.normal.family = "UDEV Gothic NF";
      };
    };
    emacs = { enable = true; };
  };
}
