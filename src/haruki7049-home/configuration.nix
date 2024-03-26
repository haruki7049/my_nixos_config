{ config, lib, pkgs, ... }:

let
  home-manager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
    sha256 = "0g51f2hz13dk953i501fmc6935difhz60741nypaqwz127hy5ldk";
  };
in {
  imports =
    [
      (import "${home-manager}/nixos")
      ../home/haruki/home.nix
      ../home/root/home.nix
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "haruki7049-home";
    nameservers = [
      "192.168.0.1"
    ];
    defaultGateway = {
      address = "192.168.0.1";
      interface = "enp4s0";
    };
    interfaces = {
      enp4s0 = {
        ipv6.addresses = [{
          address = "240f:3c:196e:1:8ad9:8731:1b45:61fd";
          prefixLength = 64;
        }];
        ipv4.addresses = [{
          address = "192.168.0.200";
          prefixLength = 24;
        }];
      };
    };
  };

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    polkit = {
      enable = true;
    };
  };

  users = {
    mutableUsers = false;
    users = {
      haruki = {
        hashedPassword = "$y$j9T$A2FjmBevK/oLEqTCfU27M0$Q.Y0e3/gr3fCC/FAPv5tIGHP89TrB9IjBtnLTiYETh3";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
      root = {
        hashedPassword = "$y$j9T$CToL.EUZAxPYjn.Fu7IfC1$LBNmqPVyqyLwujDyecwlVkIxCJr4NOmRV.DAGJrt5d8";
        isSystemUser = true;
        extraGroups = [ "root" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    deno
    nixpkgs-fmt
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  system.stateVersion = "23.11";
}
