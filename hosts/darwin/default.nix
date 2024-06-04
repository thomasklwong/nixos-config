{ agenix, config, inputs, pkgs, ... }:

let user = "thomas"; in

{
  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
    agenix.darwinModules.default
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    # /run/current-system/sw/bin/zsh
    zsh.enable = true;
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    # emacs-unstable
    agenix.packages."${pkgs.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Enable fonts dir
  fonts.fontDir.enable = true;

  # launchd.user.agents.emacs.path = [ config.environment.systemPath ];
  # launchd.user.agents.emacs.serviceConfig = {
  #   KeepAlive = true;
  #   ProgramArguments = [
  #     "/bin/sh"
  #     "-c"
  #     "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
  #   ];
  #   StandardErrorPath = "/tmp/emacs.err.log";
  #   StandardOutPath = "/tmp/emacs.out.log";
  # };

  system = {
    stateVersion = 4;

    defaults = {
      ActivityMonitor = {
        # CPU History
        IconType = 6;
        SortColumn = "% CPU";
        SortDirection = 0;
      };

      LaunchServices.LSQuarantine = false;

      NSGlobalDomain = {
        NSDocumentSaveNewDocumentsToCloud = false;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleWindowTabbingMode = "fullscreen";
      };

      # Not in default
      # NSToolbarTitleViewRolloverDelay = 0;

      # "com.apple.finder._FXSortFoldersFirst" = true;
      # "com.apple.finder.FXRemoveOldTrashItems" = true;
      # "com.apple.finder._FXSortFoldersFirstOnDesktop" = true;
      # "com.apple.finder.ShowExternalHardDrivesOnDesktop" = false;
      # "com.apple.finder.ShowRemovableMediaOnDesktop" = false;

      # "com.apple.menuextra.clock.FlashDateSeparators" = true;

      # "com.apple.HIToolbox.AppleFnUsageType" = 3;

      # "com.apple.mouse.tapBehavior" = 1;

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      dock = {
        autohide = true;
        magnification = true;
        show-recents = false;
        # persistent-apps = [ path ];
        # persistent-others = [ path ];
        
        # Start screen saver.
        wvous-tl-corner = 5;
        # Quick Note
        wvous-br-corner = 14;
      };

      finder = {
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowAMPM = false;
        ShowSeconds = true;
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
