# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, themeName, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/mutter" = { dynamic-workspaces = false; };

    # Screen blanks after 15 minutes
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 900;
    };
    # Suspend after 15 minutes
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 900;
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 900;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ara" ]) ];
      xkb-options = [ "caps:escape" "grp:alt_shift_toggle" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = false;
      enable-hot-corners = false;
      gtk-theme = "${themeName}";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri-dark = "${./wallpaper.png}";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>w" ];
      panel-run-dialog = [ "<Super>r" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-input-source = [ "<Shift>Alt_L" ];
      switch-input-source-backward = [ "<Shift>Alt_L" ];
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "default";
      speed = -0.48;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 5;
      resize-with-right-button = true;
      theme = "${themeName}";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
      home = [ "<Super>e" ];
      magnifier = [ "<Alt><Super>z" ];
      www = [ "<Super>b" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Super>Return";
        command = "ghostty";
        name = "Terminal";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
      {
        binding = "<Shift><Super>e";
        command = ''
          bash -c "gnome-screenshot -a -f /tmp/screenshot.png && tesseract /tmp/screenshot.png - | wl-copy"'';
        name = "Extract Image from Text";
      };

    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-in-panel@fthx"
        "arcmenu@arcmenu.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "clipboard-indicator@tudmotu.com"
        "caffeine@patapon.info"
        "blur-my-shell@aunetx"
        "wifiqrcode@glerro.pm.me"
        "athan@goodm4ven"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "zen-beta.desktop"
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
      ];
    };

    "org/gnome/shell/weather" = { automatic-location = true; };

    "org/gnome/shell/app-switcher" = { current-workspace-only = true; };

    "org/gnome/shell/keybindings" = {
      screenshot = [ "Print" ];
      show-screen-recording-ui = [ "<Shift><Super>r" ];
      show-screenshot-ui = [ "<Shift><Super>s" ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      toggle-message-tray = [ "<super>c" ];
      toggle-overview = [ "<super>tab" ];
    };

    "org/gnome/desktop/sound" = { event-sounds = false; };

    "org/gnome/shell/extensions/dash-in-panel" = {
      button-margin = 2;
      center-dash = false;
      colored-dot = true;
      cycle-windows = true;
      dim-dot = true;
      icon-size = 25;
      move-date = false;
      panel-height = 32;
      show-apps = false;
      show-dash = true;
      show-label = true;
      show-running = false;
    };

    "org/gnome/shell/extensions/arcmenu" = {
      highlight-search-result-terms = true;
      menu-button-appearance = "None";
      menu-layout = "Runner";
      runner-position = "Centered";
      runner-search-display-style = "Grid";
      show-activities-button = true;
    };

    "org/gnome/shell/extensions/user-theme" = { name = "${themeName}"; };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      clear-history = [ ];
      disable-down-arrow = true;
      display-mode = 0;
      enable-keybindings = true;
      history-size = 30;
      move-item-first = true;
      next-entry = [ "<Super>v" ];
      notify-on-cycle = true;
      paste-button = false;
      paste-on-select = true;
      pinned-on-bottom = true;
      prev-entry = [ "<Shift><Super>v" ];
      private-mode-binding = [ ];
      strip-text = true;
      toggle-menu = [ ];
    };

    "org/gnome/shell/extensions/athan" = {
      calculation-method = 1;
      time-format-12 = true;
      timezone = 0;
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list =
        [ "zen-beta.desktop:2" "com.mitchellh.ghostty.desktop:1" ];
    };

  };
}
