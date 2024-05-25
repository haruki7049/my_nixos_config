{ config, lib, pkgs, ... }:
let
  sshConfig = ''
    Host *
      IdentityAgent ~/.1password/agent.sock

    Host github.com
      User git

    Host gitlab.com
      User git
            
    Host haruki7049-home
      HostName ssh.haruki7049.dev
      User haruki
      ProxyCommand ${pkgs.cloudflared}/bin/cloudflared access ssh --hostname ssh.haruki7049.dev
  '';
in {
  imports = [ ./develop/develop.nix ];

  home = {
    username = "haruki";
    homeDirectory = "/home/haruki";
    packages = with pkgs; [ fd ];
    pointerCursor = let
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
    in getFrom
    "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"
    "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=" "bibata" 24;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
      };
    };
  };

  accounts.email = {
    accounts."harukiman" = {
      name = "haruki7049";
      primary = true;
      address = "harukiman@haruki7049.dev";
      realName = "Haruki Shimauchi";
      userName = "harukiman@haruki7049.dev";
      smtp = {
        host = "mail73.conoha.ne.jp";
        port = 465;
      };
      imap = {
        host = "mail73.conoha.ne.jp";
        port = 993;
      };
      thunderbird.enable = true;
      himalaya = {
        enable = false;
        #settings = {
        #  accounts.harukiman = {
        #    default = true;
        #    display-name = "haruki7049";
        #    email = "harukiman@haruki7049.dev";
        #    sync.enable = true;
        #    backend = "imap";
        #    message.send = {
        #      backend = "smtp";
        #      save-copy = true;
        #    };
        #    imap = {
        #      host = "mail73.conoha.ne.jp";
        #      port = 993;
        #      encryption = "tls";
        #      login = "harukiman@haruki7049.dev";
        #      passwd.cmd = "cat /run/secrets/harukiman@haruki7049.dev.env";
        #    };
        #    smtp = {
        #      host = "mail73.conoha.ne.jp";
        #      port = 465;
        #      encryption = "tls";
        #      login = "harukiman@haruki7049.dev";
        #      passwd.cmd = "cat /run/secrets/harukiman@haruki7049.dev.env";
        #    };
        #  };
        #};
      };
    };
  };

  programs = {
    # Enable home-manager
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "haruki7049";
      userEmail = "tontonkirikiri@gmail.com";
      extraConfig = {
        user.signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7Rjpnf4kB6UIILl8fohRn0Gz1aBYM59OHlEjdPd/gS";
        init.defaultBranch = "main";
        gpg.format = "ssh";
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        commit.gpgsign = true;
        pull.rebase = true;
      };
    };
    bat.enable = true;
    eza.enable = true;
    fzf.enable = true;
    ssh = {
      enable = true;
      extraConfig = sshConfig;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
