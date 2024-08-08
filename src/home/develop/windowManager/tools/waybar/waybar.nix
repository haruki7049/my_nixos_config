{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "hyprland/workspaces" ];
        modules-center = [ "clock" ];

        clock = {
          format = "{:%H:%M}";
        };
      };
    };
  };
}