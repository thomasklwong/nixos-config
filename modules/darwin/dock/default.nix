{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.dock;
  inherit (pkgs) stdenv dockutil;
in
{
  options = {
    local.dock.enable = mkOption {
      description = "Enable dock";
      default = stdenv.isDarwin;
      example = false;
    };

    local.dock.entries = mkOption
      {
        description = "Entries on the Dock";
        type = with types; listOf (submodule {
          options = {
            path = lib.mkOption { type = str; };
            section = lib.mkOption {
              type = str;
              default = "apps";
            };
            options = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
        readOnly = true;
      };
  };

  config =
    mkIf cfg.enable
      (
        let
          normalize = path: if hasSuffix ".app" path then path + "/" else path;
          entryURI = path: "file://" + (builtins.replaceStrings
            [" "   "!"   "\""  "#"   "$"   "%"   "&"   "'"   "("   ")"]
            ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
            (normalize path)
          );
          wantURIs = concatMapStrings
            (entry: "${entryURI entry.path}\n")
            cfg.entries;

          # It's better to construct the 'createEntries' string carefully with escaping
          # as it will be part of a larger shell command executed via sudo -u.
          # Here, we'll put the raw commands into the script block.
          # We remove 'createEntries' as a direct string concat here, and build it inside the script.
          #
          # createEntries = concatMapStrings
          #   (entry: "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n")
          #   cfg.entries;
        in
        {
          # Use a new activation script name, not 'postUserActivation'
          system.activationScripts.configureDock.text = ''
            echo >&2 "Attempting to set up the Dock for the current user..."

            # Get the logged-in user's name
            loggedInUser="$(logname)"

            # Check if a user is logged in. If not, exit gracefully.
            if [ -z "$loggedInUser" ]; then
              echo >&2 "No user logged in at activation time, skipping Dock setup."
              exit 0
            fi

            # Execute the dockutil logic as the logged-in user
            # We use /bin/bash -c "..." to ensure proper shell interpretation
            # and to handle potential spaces/special characters in paths.
            sudo -u "$loggedInUser" /bin/bash -c "
              echo >&2 \"Running Dock setup as user: $loggedInUser\"
              haveURIs=\"\$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)\"
              if ! diff -wu <(echo -n \"\$haveURIs\") <(echo -n '${wantURIs}') >&2 ; then
                echo >&2 \"Resetting Dock.\"
                ${dockutil}/bin/dockutil --no-restart --remove all
                # Reconstruct createEntries here within the user's shell
                ${concatMapStrings (entry: "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n") cfg.entries}
                killall Dock
              else
                echo >&2 \"Dock setup complete.\"
              fi
            "
          '';

          # You should remove or comment out the old 'postUserActivation' line
          # if it exists directly in your configuration to avoid conflicts.
          # system.activationScripts.postUserActivation.text = ""; # REMOVE THIS LINE
        }
      );
}
