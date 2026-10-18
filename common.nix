{ config, pkgs, lib, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.prime = { ... }: {
    home.stateVersion = "26.05";

    home.pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    systemd.user.services.hyprpolkitagent = {
      Unit = {
        Description = "Hyprland Polkit Authentication Agent";
        PartOf = [ "graphical-session.target"];
        After = [ "graphical-session.target" ]; 
        };
        Service = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Slice = "session.slice";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

    home.sessionVariables = {
      GTK_THEME = "Adwaita:dark";
      QT_STYLE_OVERRIDE = "kvantum";
    };

    qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    programs.zsh = {
        enable = true;
        oh-my-zsh.enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initContent = lib.mkMerge [
          (lib.mkOrder 100 ''
            if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
          '')
          (lib.mkOrder 1000 ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
          '')
        ];
    };



    xdg.configFile."kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
    xdg.configFile."niri/config.kdl" = {
      source =  ./dotfiles/niri/config.kdl;
      force = true;
    };  
    xdg.configFile."nvim" = {
      source = ./dotfiles/nvim;
      recursive = true;
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Needed for home-manager's dconf.settings (GTK4/libadwaita dark mode)
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
  services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter-session";
  };

  systemd.tmpfiles.packages = [ pkgs.noctalia-greeter ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X12
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh = {
      enable = true;
      settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
      };
  };

  # Nerd Fonts: FantasqueSansM for kitty, JetBrainsMono for yambar icons
  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.jetbrains-mono
  ];

  # LocalSend discovery (UDP) + transfer (TCP)
  networking.firewall = {
    allowedTCPPorts = [ 53317 22];
    allowedUDPPorts = [ 53317 ];
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users."prime" = {
    isNormalUser = true;
    description = "prime";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  # PACKAGES
  
  programs.niri.enable = true;


  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets EDITOR=nvim
  };

  programs.zsh.enable = true;

  # ENVIRONMENT / systempackages
  environment.systemPackages = with pkgs; [
    git
    kitty
    firefox
    fastfetch
    obsidian
    noctalia
    yazi
    claude-code
    bitwarden-desktop
    ripgrep
    fd
    gcc
    nodejs
    zsh-powerlevel10k
    wireguard-tools
    localsend
    lxqt.pcmanfm-qt
    gvfs
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    papirus-icon-theme
    qutebrowser
    xwayland-satellite
    noctalia-greeter
    hyprpolkitagent
    wl-clipboard
    btop


    # Rust toolchain so blink.cmp can build its own native fuzzy-matcher lib
    cargo
    rustc

    # LazyVim tooling - Nix packages instead of Mason-downloaded binaries
    stylua
    lua-language-server
    marksman
    markdownlint-cli2
    markdown-toc
    shellcheck
    shfmt
    tree-sitter
    bash-language-server
  ];
}
