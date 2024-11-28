{
  pkgs,
  lib,
  nixvim,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.lachlan = {
    home.username = "lachlan";
    home.homeDirectory = "/home/lachlan";

    home.packages = with pkgs; [
      # Applications
      gnome-disk-utility
      gnome-usage
      rockbox-utility
      asunder
    ];

    home.stateVersion = "24.05";

    home.enableNixpkgsReleaseCheck = false;

    imports = [
      nixvim.homeManagerModules.nixvim
    ];

    programs.home-manager.enable = true;

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
      #  profileExtra = ''
      #    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
      #  '';
      sessionVariables.EDITOR = "nvim";
    };

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
  };
}
