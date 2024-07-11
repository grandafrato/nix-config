{
  pkgs,
  lib,
  config,
  ...
}:

{
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.packages = with pkgs; [
    # Applications
    firefox
    gnome.nautilus
    gnome.gnome-software

    # Dev Tools
    btop
    helix
    nil
    zellij
    bat

    # notification daemon
    dunst
    libnotify

    # networking
    networkmanagerapplet
    pass-wayland
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
      terminal = "${pkgs.foot}/bin/foot";
      font = lib.mkForce "Hack Nerd Font:size=28";
      width = 40;
    };
  };

  programs.foot = {
    enable = true;
    settings.mouse.hide-when-typing = "yes";
  };

  services.pass-secret-service.enable = true;

  programs.waybar = import ./home/waybar.nix;
  stylix.targets.waybar.enable = false;

  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.systemd.enable = true;

  wayland.windowManager.hyprland.settings = import ./home/hyprland_settings.nix pkgs;

  stylix.targets.hyprland.enable = false;

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
