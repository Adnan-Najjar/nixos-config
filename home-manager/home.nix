{ config, pkgs, inputs, lib, user, ... }:
let
  theme = pkgs.sweet;
  themeName = "Sweet-Ambar-Blue-Dark-v40";
in {
  imports = [
    inputs.zen-browser.homeModules.default
    (import ./dconf.nix { inherit lib themeName; })
    ./obsidian.nix
  ];

  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
    stateVersion = "25.05";

    packages = (with pkgs; [
      # CLI
      go
      gcc
      ripgrep
      btop
      fastfetch
      eza
      tldr
      trash-cli
      gemini-cli

      # GUI
      gnome-tweaks

      # Languages Servers
      gopls
      bash-language-server
      lua-language-server
      nil
      stylua
      pyright

    ]) ++ (with pkgs.gnomeExtensions; [
      arcmenu
      caffeine
      blur-my-shell
      dash-in-panel
      clipboard-indicator
      appindicator
      athantimes
      user-themes
      wifi-qrcode
      auto-move-windows
      grand-theft-focus
    ]);

    file = {
      "${config.home.homeDirectory}/Pictures/wallpaper.png".source =
        ./wallpaper.png;
    };

    sessionVariables = {
      MANPATH = "/usr/share/man:/usr/local/share/man:$MANPATH";
      GOPATH = "$HOME/.go";
      PATH = "$PATH:$HOME/.go/bin:$HOME/.local/bin";
      MANPAGER =
        "sh -c 'awk '''{ gsub(/x1B[[0-9;]*m/, \"\", $0); gsub(/.x08/, \"\", $0); print }''' | bat -p -lman'";
    };
  };

  # GUI
  gtk = {
    enable = true;
    gtk3.theme = {
      name = themeName;
      package = theme;
    };
    gtk4.theme = {
      name = themeName;
      package = theme;
    };
  };

  programs = {
    ghostty = {
      enable = true;
      clearDefaultKeybinds = true;
      settings = {
        theme = "tokyonight";
        font-family = "CaskaydiaMono Nerd Font";
        font-size = 16;
        mouse-hide-while-typing = true;
        background-blur-radius = 20;
        background-opacity = 0.9;
        maximize = true;
        keybind = [
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+c=copy_to_clipboard"
        ];
      };
    };
    zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.passff-host ];
      profiles.${user.username} = {
        id = 0;
        name = "${user.username}";
        path = "${user.username}.default";
        isDefault = true;
        settings = {
          "zen.welcome-screen.seen" = true;
          "zen.view.use-single-toolbar" = false;
          "zen.workspaces.continue-where-left-off" = true;
          "general.autoScroll" = true;
          "layout.css.always_underline_links" = true;
          "zen.view.show-newtab-button-top" = false;
          "zen.glance.activation-method" = "shift";
          "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
          "network.trr.mode" = 2;
          "network.trr.uri" = "https://firefox.dns.nextdns.io/";
        };
        search = {
          force = true;
          default = "Unduck";
          engines = {
            "Unduck" = {
              urls = [{ template = "https://unduck.link?q={searchTerms}"; }];
            };
            "bing".metaData.hidden = true;
            "google".metaData.hidden = true;
            "ddg".metaData.hidden = true;
            "wikipedia".metaData.hidden = true;
          };
        };
      };
      policies = {
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        StartDownloadsInTempDirectory = true;
        ExtensionSettings = with builtins;
          let
            extension = shortId: uuid: {
              name = uuid;
              value = {
                install_url =
                  "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in listToAttrs [
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "sponsorblock" "sponsorBlocker@ajay.app")
            (extension "youtube-recommended-videos" "myallychou@gmail.com")
            (extension "multi-account-containers" "@testpilot-containers")
            (extension "darkreader" "addon@darkreader.org")
            (extension "istilldontcareaboutcookies" "idcac-pub@guus.ninja")
            (extension "haramblur" "info@haramblur.com")
            (extension "simple-translate" "simple-translate@sienori")
            (extension "proton-vpn-firefox-extension" "vpn@proton.ch")
            (extension "pssff" "passff@invicem.pro")
          ];
      };
    };

    # CLI
    gpg = {
      enable = true;
      publicKeys = [{
        source = ./public-key.txt;
        trust = 5;
      }];
    };
    password-store.enable = true;
    bat = {
      enable = true;
      config = {
        pager = "less -FirSwX";
        theme = "TwoDark";
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        mason-nvim
        mason-lspconfig-nvim
        mason-tool-installer-nvim
        blink-cmp
        nvim-treesitter.withAllGrammars
        markview-nvim
        vim-illuminate
        supermaven-nvim
        nvim-web-devicons
        gitsigns-nvim
        vim-sleuth
        tokyonight-nvim
        lualine-nvim
        mini-pick
        mini-files
        undotree
      ];
      extraLuaConfig = builtins.readFile ./nvim.lua;
    };
    tmux = {
      enable = true;
      prefix = "C-s";
      keyMode = "vi";
      mouse = true;
      newSession = true;
      sensibleOnTop = true;
      extraConfig = ''
        set -ag terminal-overrides ",$TERM:Tc"
        set-option -g status-style bg=default
      '';
    };

    git = {
      enable = true;
      userName = user.fullName;
      userEmail = user.email;
      aliases = {
        prettylog =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      };
      extraConfig = {
        init.defaultBranch = "main";
        color.ui = true;
        credential.helper = "store";
      };
    };
    gh.enable = true;

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreAllDups = true;
        size = 10000;
        save = 10000;
      };

      shellAliases = {
        cd = "z";
        cat = "bat";
        ip = "ip -c";
        cp = "cp -i";
        mv = "mv -i";
        rm = "trash -v";
        mkdir = "mkdir -p";
        pst = "wl-paste";
        cpy = "wl-copy";
        urls = "grep -oP -N --color=never 'http[s]?://\\S+'";
        ppt2txt =
          "unzip -qc \"$1\" \"ppt/slides/slide*.xml\" | grep -oP '(?<=\\<a:t\\>).*?(?=\\</a:t\\>)'";
        ".." = "cd ..";
        ls = "eza --icons";
        la = "eza -a --icons";
        ll = "eza -l --icons --total-size";
        lt = "eza --icons --tree -I .git --group-directories-first";
        nrs = "sudo nixos-rebuild switch --flake /etc/nixos";
        gemini = "GEMINI_API_KEY=$(pass api/gemini) gemini";
      };

      initContent = ''
        # Completion cache path setup
        typeset -g compfile="$HOME/.cache/.zcompdump"

        if [[ -d "$comppath" ]]; then
                [[ -w "$compfile" ]] || rm -rf "$compfile" >/dev/null 2>&1
        fi

        WORDCHARS=''${WORDCHARS//\/} # Don't consider '/' character part of the word

        # configure key keybindings
        bindkey -e                                        # emacs key bindings
        bindkey ' ' magic-space                           # do history expansion on space
        bindkey '^[[1;5C' forward-word                    # ctrl + ->
        bindkey '^[[1;5D' backward-word                   # ctrl + <-
        bindkey '^X' edit-command-line                    # ctrl + x to open in editor
        # Override -h and --help with bat
        alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

        # Dont open tmux in tty or ssh
        if [[ $(tty) == *"pts"* ]]; then
                if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
                        tmux attach -t main &> /dev/null || tmux new -s main &> /dev/null 
                fi
        fi

        open() {
          if [ -z "$@" ]; then
            xdg-open . &>/dev/null &
            disown
          else
            xdg-open "$@" &>/dev/null &
            disown
          fi
        }

        clear; fastfetch -c examples/9.jsonc
      '';
    };
  };

  # Open Terminal and Browser on startup
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop"
      "${
        inputs.zen-browser.packages.${pkgs.system}.default
      }/share/applications/zen-beta.desktop"
    ];
  };

}
