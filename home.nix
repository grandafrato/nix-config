{ pkgs, lib, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.lachlan = {
    home.username = "lachlan";
    home.homeDirectory = "/home/lachlan";

    home.packages = with pkgs; [
      # Applications
      gnome.nautilus
      gnome.gnome-software

      # Dev Tools
      btop
      helix
      nil
      zellij
      bat

      # notification daemon
      libnotify

      # networking
      networkmanagerapplet
      networkmanager-openvpn
      kdePackages.kwallet
      pass-wayland
    ];

    programs.firefox.enable = true;

    home.stateVersion = "24.05";

    home.enableNixpkgsReleaseCheck = false;

    programs.home-manager.enable = true;

    programs.bash = {
      enable = true;
      shellAliases = {
        z = "zellij";
        freyr = "docker run -it --rm -v $PWD:/data:z freyrcli/freyrjs";

        # Git Aliases
        g = "git";
        ga = "git add";
        gaa = "git add -A";
        gc = "git commit";
        gcl = "git clone";
        gp = "git push";
      };
      profileExtra = ''
        export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
      '';
      sessionVariables.EDITOR = "hx";
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
      # settings.theme = "dracula_at_night";
      settings.keys.insert = {
        j.k = "normal_mode";
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "elixir";
          auto-format = true;
        }
      ];
    };

    programs.zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        default_layout = "compact";
        copy_command = "wl-copy";
      };
    };

    programs.fuzzel = {
      enable = true;
      settings.main = {
        layer = "overlay";
        terminal = "${pkgs.kitty}/bin/kitty";
        font = lib.mkForce "Hack Nerd Font:size=18";
        width = 40;
      };
    };

    # programs.foot = {
    #   enable = true;
    #   settings = {
    #     mouse.hide-when-typing = "yes";
    #     main.app-id = "Terminal";
    #     key-bindings.fullscreen = "F11";
    #   };
    # };

    programs.kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        package.disabled = true;
        elixir.disabled = true;
      };
    };

    services.pass-secret-service.enable = true;

    programs.waybar = import ./home/waybar.nix;
    stylix.targets.waybar.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = import ./home/hyprland_settings.nix pkgs;
    };

    stylix.targets.hyprland.enable = false;

    programs.wlogout.enable = true;

    services.dunst = {
      enable = true;
      settings.global.corner_radius = 8;
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [ "/usr/share/backgrounds/desktop.jpg" ];
        wallpaper = [ ",/usr/share/backgrounds/desktop.jpg" ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          # After 2.5 minutes, set monitor to minimum brightness, and return to
          # to previous brightness on awake.
          {
            timeout = 150;
            on-timeout = "brillo -O && brillo -S 0.01";
            on-resume = "brillo -I";
          }
          # After 5 minutes, lock the screen.
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          # After 5 and 1/2 minutes, turn the screen off, but turn it bacl on if
          # activity is detected after timeout has been fired.
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          # Suspend computer after 30 minutes.
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        source = "${./home/hyprlock/mocha.conf}";
        "$bg_path" = "${./home/hyprlock/background.png}";
        "$face_path" = "${./home/hyprlock/face.png}";
      };
      extraConfig = builtins.readFile ./home/hyprlock/hyprlock.conf;
    };
  };
}
