{ pkgs, ... } :

rec {
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.packages = with pkgs; [
    # Applications
    firefox
    gnome.nautilus

    # Dev Tools
    alacritty
    btop
    helix
    nil
    zellij

    # notification daemon
    dunst
    libnotify

    # networking
    networkmanagerapplet
  ];

  home.stateVersion = "24.05";

  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;

  programs.bash.shellAliases = {
    z = "zellij";

    # Git Aliases
    g = "git";
    ga = "git add";
    gc = "git commit";
    gcl = "git clone";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.git = {
    enable = true;
    userEmail = "github.defender025@passmail.net";
    userName = "Lachlan Wilger";
    signing = {
      key = "2EE29D3CE347115D";
      signByDefault = true;
    };
  };

  programs.helix = {
    enable = true;
    settings.theme = "dracula_at_night";
    settings.keys.insert = {
      j.k = "normal_mode";
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
    }];
  };

  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      pane_frames = false;
      theme = "dracula";
      default_layout = "compact";
      copy_command = "wl-copy";
    };
  };

  programs.waybar = {
    enable = true;
    settings.minibar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "wireplumber" "backlight" "battery" ];

      "hyprland/workspaces" = {
        format = "<sub>{icon}</sub> {windows}";
      };

      "hyprland/window" = {
        format = "{icon} {title}";
        icon = true;
        separate-outputs = true;
      };

      wireplumber.format = "Volume: {volume}% ";

      backlight.format = "Brightness: {percent}%";

      battery = {
        interval = 60;
        state = {
          warning = 20;
          critical = 10;
        };
        format = "Battery: {capacity}%";
      };
    };
  };

  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.systemd.enable = true;

  wayland.windowManager.hyprland.settings = {
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
    bind = [
      # Application Binds
      "$mod, F, exec, firefox"
      "$mod, T, exec, $terminal"
      "$mod, E, exec, $fileManager"

      # Brightness Control
      ", XF86MonBrightnessUp, exec, ${pkgs.brillo}/bin/brillo -q -A 5"
      ", XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 5"

      # Logout
      "$mod, U, exec, loginctl kill-user ${home.username}"
    ]
    ++ (
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10)
    );

    # Media Control
    bindel = [
      ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
    bindl = [ ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
  };
}
