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

  ids.gids.nixbld = 350;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
      download-buffer-size = 5368709120;
    }

    gc = {
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

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  environment = {
    shells = [ pkgs.bashInteractive pkgs.zsh ];
  };
  # This does not work. Need to manually fix it.
  # users.users.thomas.shell = pkgs.zsh;

  system = {
    primaryUser = "thomas";

    stateVersion = 4;

    checks = {
      # Turn off NIX_PATH warnings now that we're using flakes
      verifyNixPath = false;
    };

    defaults = {
      ActivityMonitor = {
        # CPU History
        IconType = 6;
        SortColumn = "% CPU";
        SortDirection = 0;
      };

      CustomSystemPreferences = {};

      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
        };

        "com.apple.menuextra.clock" = {
          FlashDateSeparators = true;
        };
      };

      LaunchServices.LSQuarantine = false;

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleScrollerPagingBehavior = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      loginwindow.GuestEnabled = false;

      # Firewall
      alf = {
        allowdownloadsignedenabled = 1;
        allowsignedenabled = 1;
      };

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

      menuExtraClock = {
        Show24Hour = true;
        ShowAMPM = false;
        # Always
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
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
