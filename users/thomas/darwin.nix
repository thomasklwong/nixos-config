{ inputs, pkgs, ... }:

{
  # nixpkgs.overlays = import ../../lib/overlays.nix ++ [
  #   (import ./vim.nix { inherit inputs; })
  # ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  homebrew = {
    enable = true;
    taps = [
      "gcenx/wine"
      "homebrew/cask-versions"
      "majd/repo"
    ];
    brews = [
      "tsduck"
    ];
    casks  = [
      "1password"
      "adobe-digital-editions"
      "android-studio"
      "appcleaner"
      "brave-browser"
      "brave-browser-beta"
      "calibre"
      "charles"
      "coconutbattery"
      "disk-drill"
      "firefox"
      "firefox-developer-edition"
      "floorp"
      "github-beta"
      "google-chrome"
      "google-chrome-beta"
      "google-chrome-canary"
      "google-drive"
      "handbrake"
      "iina"
      "ipatool"
      "keka"
      "kindle-previewer"
      "logi-options-plus"
      "macs-fan-control"
      "microsoft-edge"
      "mullvad-browser"
      "nordlayer"
      "nordvpn"
      "notunes"
      "obsidian"
      "pgadmin4"
      "portingkit"
      "postman"
      "postman-agent"
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "teamviewer"
      "telegram"
      "the-unarchiver"
      "ui"
      "upscayl"
      "utm"
      "visual-studio-code"
      "vlc"
      "vysor"
      "warp"
      "wine-stable"
      "wineskin"
      "wireshark"
      "xquartz"
      "yam-display"
      "zenmap"
      # "cleanshot"
      # "discord"
      # "google-chrome"
      # "hammerspoon"
      # "imageoptim"
      # "istat-menus"
      # "monodraw"
      # "raycast"
      # "rectangle"
      # "screenflow"
      # "slack"
      # "spotify"
    ];
    masApps = {
      "HP Smart" = 1474276998;
      "1Password for Safari" = 1569813296;
      "iMovie" = 408981434;
      "Pages" = 409201541;
      "Disk Speed Test" = 425264550;
      "Keynote" = 409183694;
      "Xcode" = 497799835;
      "GoPro Player" = 1460836908;
      "LINE" = 539883307;
      "Numbers" = 409203825;
    };
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.thomas = {
    home = "/Users/thomas";
    shell = pkgs.zsh;
  };
}
