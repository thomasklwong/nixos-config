{ config, pkgs, lib, ... }:

let name = "Thomas Wong";
    user = "thomas";
    email = "1935201+thomasklwong@users.noreply.github.com"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;

    history = {
      ignorePatterns = [
        "pwd"
        "ls"
        "cd"
      ];
    };

    initContent = lib.mkBefore ''
      # 1. Enable unique constraints on PATH to auto-remove duplicates
      typeset -U path

      # 2. Load Nix Daemon (if not already loaded by system zshrc)
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # 3. Environment Variables
      export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
      export ANDROID_HOME=$HOME/Library/Android/sdk

      if [ -d "$ANDROID_HOME/ndk" ]; then
         export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 "$ANDROID_HOME/ndk" | head -n 1)"
      fi

      # 4. Path Construction (Ordered: Specific -> General)
      # We explicitly set the path array. $path at the end includes existing system paths.
      path=(
        "$HOME/.local/bin"
        "$HOME/.local/share/bin"
        "$ANDROID_HOME/emulator"                 # This gives the `emulator` command
        "$ANDROID_HOME/platform-tools"           # This gives the `adb` command
        "$ANDROID_HOME/cmdline-tools/latest/bin" # This gives the `avdmanager` and `sdkmanager` command
        "/opt/homebrew/bin"
        $path
      )

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      eval "$(mise activate)"
    '';

    shellAliases = {
      ls="ls --color=auto";
      search="rg -p --glob '!node_modules/*' ";
      diff="difft";
    };
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    settings = {
      user = {
        name = name;
        email = email;
      };
      init = {
        defaultBranch = "main";
      };
      # core = {
        # editor = "vim";
        # autocrlf = "input";
      # };
      # commit.gpgsign = true;
      # pull.rebase = true;
      # rebase.autoStash = true;
    };
    lfs = {
      enable = true;
    };
  };
}
