{ config, pkgs, lib, home-manager, _1password-shell-plugins, ... }:

let
  user = "thomas";
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  sharedFiles = import ../shared/files.nix { inherit user config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    brews = pkgs.callPackage ./brews.nix {};
    casks = pkgs.callPackage ./casks.nix {};
    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      extraFlags = [
        "--verbose"
        "--debug"
      ];
    };

    masApps = {
      "HP Smart" = 1474276998;
      "1Password for Safari" = 1569813296;
      # "iMovie" = 408981434;
      # "Pages" = 409201541;
      "Disk Speed Test" = 425264550;
      # "Keynote" = 409183694;
      "Xcode" = 497799835;
      "GoPro Player" = 1460836908;
      "LINE" = 539883307;
      # "Numbers" = 409203825;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      imports = [
        _1password-shell-plugins.hmModules.default
      ];

      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
          # { "emacs-launcher.command".source = myEmacsLauncher; }
        ];

        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      # manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = { 
    dock = {
      enable = true;
      entries = [
        { path = "/Applications/LINE.app/"; }
        { path = "/Applications/Signal.app/"; }
        { path = "/Applications/Slack.app/"; }
        { path = "/Applications/Floorp.app/"; }
        { path = "/Applications/Firefox.app/"; }
        { path = "/Applications/Firefox Developer Edition.app/"; }
        { path = "/Applications/Google Chrome.app/"; }
        { path = "/Applications/Google Chrome Beta.app/"; }
        { path = "/Applications/Google Chrome Canary.app/"; }
        { path = "/Applications/Brave Browser.app/"; }
        { path = "/Applications/Brave Browser Beta.app/"; }
        { path = "/Applications/Microsoft Edge.app/"; }
        { path = "/Applications/Mullvad Browser.app/"; }
        { path = "/Applications/Safari.app/"; }
        { path = "/Applications/1Password.app/"; }
        { path = "/Applications/Alacritty.app/"; }
        { path = "/Applications/GitHub Desktop.app/"; }
        { path = "/Applications/Obsidian.app/"; }
        { path = "/Applications/Visual Studio Code.app/"; }
        {
          path = "${config.users.users.${user}.home}/Downloads";
          section = "others";
          options = "--sort name --view grid --display stack";
        }
        #{
        #  path = toString myEmacsLauncher;
        #  section = "others";
        #}
        #{
        #  path = "${config.users.users.${user}.home}/.local/share/";
        #  section = "others";
        #  options = "--sort name --view grid --display folder";
        #}
        #{
        #  path = "${config.users.users.${user}.home}/.local/share/downloads";
        #  section = "others";
        #  options = "--sort name --view grid --display stack";
        #}
       ];
     };
   };
}
