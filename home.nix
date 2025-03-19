{ config, pkgs, ... }:

let open3d_version = "0.19.0"; in {
# Home Manager needs a bit of information about you and the paths it should manage.
home.username = "geostartico";
home.homeDirectory = "/home/geostartico"; #  This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing. The home.packages option allows you to install Nix packages into your environment.
  home.packages =  [
      pkgs.zsh-powerlevel10k pkgs.fira-code-nerdfont pkgs.clang-tools # # Adds the 'hello' command to your environment. It prints a friendly # "Hello, world!" when run. pkgs.hello
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # Module-specific packages
    pkgs.procps          # CPU and memory
    pkgs.util-linux      # Memory
    pkgs.upower          # Battery
    pkgs.networkmanager  # Network
    pkgs.wirelesstools   # Wi-Fi signal strength
    pkgs.pulseaudio      # Audio

    # Custom launcher
    pkgs.rofi
    pkgs.fira-code
    pkgs.font-awesome
    pkgs.lm_sensors
    pkgs.acpi
    pkgs.bluez
    pkgs.brightnessctl
  ];
  home.file.".open3d" = {
      source = builtins.fetchTarball {
          url = "https://github.com/isl-org/Open3D/releases/download/v${open3d_version}/open3d-devel-linux-x86_64-cxx11-abi-${open3d_version}.tar.xz";
          sha256 = "sha256:0c07c5dfl09682ag20lh9mg4pnl2rmc1gsy1qmd0wd7swylarvfx"; # Replace with the actual SHA-256 hash
      };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = '' org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    #".config/starship.toml".source = ./starship.toml;
    #".config/nvim/init.vim".source = ./init.vim;
    "Pictures/firepunch.png".source = ./firepunch.png;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/geostartico/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;

    #oh-my-zsh = {
    #    enable = true;
    #    plugins = [
    #        "git" "sudo"
    #    ];
    #    theme = "powerlevel10k/powerlevel10k";
    #    extraConfig = ''
    #  # Load Powerlevel10k
    #  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    #'';
    #};
  };
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    enableZshIntegration = true;
    settings = {
    format = 
        "[](${config.scheme.withHashtag.base03})$username$hostname$conda[](fg:${config.scheme.withHashtag.base03}bg:${config.scheme.withHashtag.base0D})$directory [](fg:${config.scheme.withHashtag.base0D}bg:${config.scheme.withHashtag.base0F})$git_branch$git_status[](fg:${config.scheme.withHashtag.base0F}bg:${config.scheme.withHashtag.base00})";
      add_newline = false;
      username = {
        show_always = true;
        style_user = "fg:${config.scheme.withHashtag.base06} bg:${config.scheme.withHashtag.base03}";
        format = "[$user]($style)";
        disabled = false;
      };
      hostname = {
        ssh_only = false;
        style = "fg:${config.scheme.withHashtag.base06} bg:${config.scheme.withHashtag.base03}";
        format = "[@$hostname ]($style)";
        disabled = false;
      };
    conda = {
        style = "fg:${config.scheme.withHashtag.base06} bg:${config.scheme.withHashtag.base03}";
        format = "[$symbol$environment]($style)";
    };
    directory = {
        style = "fg:${config.scheme.withHashtag.base00} bg:${config.scheme.withHashtag.base0D}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
    };
    git_branch = {
        symbol = "";
        style = "fg:${config.scheme.withHashtag.base00} bg:${config.scheme.withHashtag.base0F}";
        format = "[ $symbol $branch ]($style)";
    };
    git_status = {
        style = "fg:${config.scheme.withHashtag.base00} bg:${config.scheme.withHashtag.base0F}";
        format = "[$all_status$ahead_behind ]($style)";
    };
       character = {
         success_symbol = "[➜](bold green)";
         error_symbol = "[✗](bold red)";
       };
    };


      # package.disabled = true;
    };
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
	extraConfig = builtins.readFile ./init.vim;
        plugins = with pkgs.vimPlugins; [
            dracula-nvim
            vim-devicons
            ultisnips
            nerdtree
            nerdcommenter
            vim-startify
            coc-nvim
            nightfox-nvim
        ];
    };

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";
                position = "top";
                height = 30;
                margin = "0 0 0 0";
                modules-left = [ "river/tags" "custom/launcher" ];
                modules-center = [ "river/window" ];
                modules-right = [ "cpu" "memory" "battery" "network" "pulseaudio" "clock" "tray"];

                "river/tags" = {
                    num-tags = 9; # Number of tags (workspaces)
                   #     tag-labels = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]; # Labels for tags
                   #     active-only = false; # Show only active tags
                };

                "river/window" = {
                    format = "{}";
                    max-length = 50;
                };

                cpu = {
                    format = "CPU: {usage}%";
                };

                memory = {
                    format = "Mem: {}%";
                };

                battery = {
                    format = "{capacity}% {icon}";
                    format-icons = [ "" "" "" "" "" ];
                };

                network = {
                    format-wifi = "{essid} ({signalStrength}%) ";
                    format-ethernet = "{ipaddr}/{cidr} ";
                    format-disconnected = "Disconnected ⚠";
                };

                pulseaudio = {
                    format = "{volume}% {icon}";
                    format-icons = [ "" "" "" ];
                };

                clock = {
                    format = "{:%H:%M}";
                };

                "custom/launcher" = {
                    format = ""; # NixOS logo or any other icon
                        on-click = "rofi -show drun"; # Launch Rofi on click
                };
                tray = {
                    icon-size = 20;
                };
            };
        };

        style = ''
            * {
border: none;
        border-radius: 0;
        font-family: "Fira Code";
        font-size: 15px;
        min-height: 0;
        margin: 0 7px;
            }

        window#waybar {
background: #2e3440;
color: #d8dee9;
        }


#cpu {
color: #8fbcbb;
}

#memory {
color: #88c0d0;
}

#battery {
color: #a3be8c;
}

#network {
color: #81a1c1;
}

#pulseaudio {
color: #b48ead;
}

#clock {
color: #ebcb8b;
}
#tags button.occupied {
color: #ebcb8b;
}
#tags button.focused {
color: #b48ead;
}

#custom-launcher {
color: #d8dee9;
padding: 0 10px;
}
'';
};
programs.foot = {
    enable = true;
    settings.main = {
        font = "FiraCode Nerd Font:size=11";
    };
};
programs.swaylock = {
    enable = true;
    settings = {
    image="$HOME/Pictures/firepunch.png";
        scaling="fill";
        font="FiraCode Nerd Font";
        font-size=20;

# Ring
        indicator-radius=115;
# line-uses-ring
        line-color="#3b4252";
        text-color="#d8dee9";
        inside-color="#2e344098";
        inside-ver-color="#5e81ac";
        line-ver-color="#5e81ac";
        ring-ver-color="#5e81ac98";
        ring-color="#4c566a";
        key-hl-color="#5e81ac";
        separator-color="#4c566a";
        layout-text-color="#eceff4";
        line-wrong-color="#d08770";

    };
};
services = {
    swayidle = {
      enable = true;
      package = pkgs.swayidle;
      timeouts = [
        { 
          timeout = 1070;
          command = "swaylock";
        }

        {
          timeout = 2000;
          command = "'systemctl suspend'";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "swaylock";
        }
      ];
    };
  };
}
