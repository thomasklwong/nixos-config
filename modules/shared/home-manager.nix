{ config, pkgs, lib, ... }:

let name = "Thomas Wong";
    user = "thomas";
    email = "1935201+thomasklwong@users.noreply.github.com"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    cdpath = [ "~/.local/share/src" ];
    plugins = [
      # {
      #    name = "powerlevel10k";
      #    src = pkgs.zsh-powerlevel10k;
      #    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # }
      # {
      #    name = "powerlevel10k-config";
      #     src = lib.cleanSource ./config;
      #     file = "p10k.zsh";
      # }
    ];

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # According to Tauri's doc
      # Also ANDROID_HOME and NDK_HOME happened after this
      export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

      export ANDROID_HOME=$HOME/Library/Android/sdk
      export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"

      # Define variables for directories
      # This will be last added path
      export PATH=$ANDROID_HOME/tools:$PATH
      export PATH=$ANDROID_HOME/tools/bin:$PATH
      export PATH=$ANDROID_HOME/platform-tools:$PATH
      export PATH=$ANDROID_HOME/emulator:$PATH
      export PATH=/opt/homebrew/bin:$PATH
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH
      # This will be first added path

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search="rg -p --glob '!node_modules/*' "  # Added quotes around the alias command

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'

      eval "$(mise activate)"
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      # core = {
        # editor = "vim";
        # autocrlf = "input";
      # };
      # commit.gpgsign = true;
      # pull.rebase = true;
      # rebase.autoStash = true;
    };
  };
}
