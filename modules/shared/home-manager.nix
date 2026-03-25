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
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
      ignorePatterns = [
        "pwd"
        "ls"
        "cd"
        "clear"
        "history"
        "exit"
        "fg"
        "bg"
        "top"
        "htop"
        "btop"
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

      if [ -d "$ANDROID_HOME/ndk" ]; then
         export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 "$ANDROID_HOME/ndk" | head -n 1)"
      fi

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
      agy="/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity";
    };
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    signing.format = "openpgp";
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
