{
  pkgs,
  lib,
  nixvim,
  hyprland-pkgs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup1";
  home-manager.users.lachlan = {
    home.username = "lachlan";
    home.homeDirectory = "/home/lachlan";

    home.packages = with pkgs; [
      # Applications
      nautilus
      gnome-disk-utility
      gnome-usage
      gnome-software
      rockbox-utility
      asunder
    ];

    home.stateVersion = "24.05";

    home.enableNixpkgsReleaseCheck = false;

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Quintom_Snow";
    };

    gtk = {
      enable = true;

      theme = {
        package = lib.mkForce pkgs.rose-pine-gtk-theme;
        name = lib.mkForce "rose-pine";
      };

      font.name = "JetBrainsMono Nerd Font Mono";
    };

    imports = [
      nixvim.homeManagerModules.nixvim
    ];

    stylix.iconTheme = {
      enable = true;
      package = pkgs.rose-pine-icon-theme;
      dark = "rose-pine";
      light = "rose-pine";
    };

    programs.home-manager.enable = true;

    programs.firefox.enable = true;

    programs.bash = {
      enable = true;
      shellAliases = {
        z = "zellij";
        v = "nvim";
        t = "tmux";

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
      sessionVariables = {
        EDITOR = "nvim";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
      };
    };

    services.gnome-keyring.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    services.easyeffects.enable = true;

    programs.git = {
      enable = true;
      userEmail = "github.defender025@passmail.net";
      userName = "Lachlan Wilger";
      signing = {
        key = "2EE29D3CE347115D";
        signByDefault = true;
      };
    };

    programs.nixvim = import ./home/nixvim.nix;

    programs.tmux = {
      enable = true;

      escapeTime = 0;
      keyMode = "vi";

      prefix = "C-a";

      terminal = "xterm-kitty";
      shell = "/run/current-system/sw/bin/bash";
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
      enableBashIntegration = false;
      settings = {
        pane_frames = false;
        default_layout = "compact";
        copy_command = "wl-copy";
        default_shell = "/run/current-system/sw/bin/bash";
      };
    };

    programs.btop.enable = true;
    programs.bat.enable = true;

    programs.fuzzel = {
      enable = true;
      settings.main = {
        layer = "overlay";
        terminal = "${pkgs.kitty}/bin/kitty";
        font = lib.mkForce "JetBrainsMono NF SemiBold:size=12";
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

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland-pkgs.hyprland;
      portalPackage = hyprland-pkgs.xdg-desktop-portal-hyprland;
      systemd.enable = true;
      settings = import ./home/hyprland_settings.nix pkgs;
    };
    stylix.targets.hyprland.enable = false;

    programs.waybar = import ./home/waybar.nix;
    stylix.targets.waybar.enable = false;

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
        preload = "${./backgrounds/Mountains.png}";
        wallpaper = ",${./backgrounds/Mountains.png}";
      };
    };
    stylix.targets.hyprpaper.enable = false;

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
        "$bg_path" = "${./backgrounds/Clearnight.jpg}";
        "$face_path" = "${./home/hyprlock/face.png}";
      };
      extraConfig = builtins.readFile ./home/hyprlock/hyprlock.conf;
    };
  };
}
