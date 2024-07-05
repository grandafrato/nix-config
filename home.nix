{ pkgs, ... }:

{
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.packages = with pkgs; [
    # Applications
    firefox
    gnome.nautilus
    gnome.gnome-software

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

  programs.bash = {
    enable = true;
    shellAliases = {
      z = "zellij";

      # Git Aliases
      g = "git";
      ga = "git add";
      gc = "git commit";
      gcl = "git clone";
    };
    profileExtra = ''
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/shar:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
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
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];
  };

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      theme = "dracula";
      default_layout = "compact";
      copy_command = "wl-copy";
    };
  };

  programs.fuzzel = {
    enable = true;
    settings.main = {
      layer = "overlay";
      terminal = "alacritty";
    };
  };

  programs.waybar = {
    enable = true;
    settings.minibar = {
      layer = "top";
      position = "top";
      passthrough = false;
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "wireplumber"
        "backlight"
        "battery"
      ];

      "hyprland/workspaces" = {
        format = "<sub>{icon}</sub> {windows}";
      };

      "hyprland/window" = {
        # format = "{icon} {title}";
        # icon = true;
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

  wayland.windowManager.hyprland.settings = import ./home/hyprland_settings.nix pkgs;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = [ "/usr/share/backgrounds/desktop.jpg" ];
      wallpaper = [ ",/usr/share/backgrounds/desktop.jpg" ];
    };
  };
}
