{ pkgs, ... }:
{
  # Monitor Settings
  monitor = [
    "eDP-1,preferred,auto,1"
    ",preferred,auto-left,1"
  ];
  xwayland.force_zero_scaling = true;

  # Startup
  exec-once = [
    "waybar"
    "nm-applet"
  ];

  general = {
    gaps_out = 6;
    gaps_in = 3;

    border_size = 2;
    resize_on_border = false;

    allow_tearing = false;

    layout = "dwindle";
  };

  decoration = {
    rounding = 10;

    active_opacity = 1.0;
    inactive_opacity = 1.0;

    drop_shadow = false;

    blur.enabled = false;
  };

  # animations.enabled = false;

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master.new_status = "master";

  misc = {
    disable_hyprland_logo = true;
    vfr = true;
  };

  # Applications
  "$terminal" = "${pkgs.kitty}/bin/kitty";
  "$fileManager" = "nautilus";

  # Input Tuning
  input = {
    kb_layout = "us";
    sensitivity = 1.0;
    touchpad.natural_scroll = true;
  };

  # Key Binds
  "$mod" = "SUPER";
  bind =
    [
      # Application Binds
      "$mod, F, exec, firefox"
      "$mod, T, exec, $terminal"
      "$mod, E, exec, $fileManager"
      "$mod, S, exec, gnome-software"
      "$mod, A, exec, ${pkgs.fuzzel}/bin/fuzzel"

      # Manage Applications
      "$mod, Q, killactive"
      "$mod, V, togglefloating"
      "$mod, P, pseudo, # dwindle"
      "$mod, G, togglesplit, # dwindle"

      # Move Windows
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      # Brightness Control
      ", XF86MonBrightnessUp, exec, ${pkgs.brillo}/bin/brillo -q -A 5"
      ", XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 5"

      # Logout
      "$mod, U, exec, ${pkgs.wlogout}/bin/wlogout"
    ]
    ++ (builtins.concatLists (
      builtins.genList (
        x:
        let
          ws =
            let
              c = (x + 1) / 10;
            in
            builtins.toString (x + 1 - (c * 10));
        in
        [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      ) 10
    ));

  # Media Control
  bindel = [
    ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  ];
  bindl = [
    ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
  ];

  # Move and Resize Windows with Mouse
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  # Prevent Maximize Event
  windowrulev2 = [ "suppressevent maximize, class:.*" ];
}
