{
  pkgs,
  lib ? pkgs.lib,
}:

let
  sshConfig = ''
    Host *
      IdentityFile ~/.ssh/haruki7049

    Host github.com
      User git

    Host gitlab.com
      User git

    Host keyserver
      HostName keyserver.haruki7049.dev
      User haruki
      ProxyCommand ${pkgs.cloudflared}/bin/cloudflared access ssh --hostname keyserver.haruki7049.dev
  '';
in

{
  haruki = {
    imports = [
      ./develop
    ];

    home = {
      username = "haruki";
      homeDirectory = lib.mkForce "/Users/haruki";
    };

    programs = {
      # Enable home-manager
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "haruki7049";
        userEmail = "tontonkirikiri@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          commit.gpgsign = true;
          gpg.format = "ssh";
          user.signingkey = "~/.ssh/haruki7049";
        };
      };
      ssh = {
        enable = true;
        extraConfig = sshConfig;
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };
}
