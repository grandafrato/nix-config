{ pkgs, ... }:
{
  # Monitor Settings
  monitor = ",preferred,auto,0.75";
  xwayland.force_zero_scaling = true;

  # Startup
  exec-once = [ "waybar" ];

  # Applications
  "$terminal" = "alacritty";
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

      # Brightness Control
      ", XF86MonBrightnessUp, exec, ${pkgs.brillo}/bin/brillo -q -A 5"
      ", XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 5"

      # Logout
      "$mod, U, exec, loginctl kill-user lachlan"
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
}
