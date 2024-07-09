{ config, pkgs, lib, ... }:

let name = "Thomas Wong";
    user = "thomas";
    email = "1935201+thomasklwong@users.noreply.github.com"; in
{
  _1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [gh awscli2];
  };

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

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      # This will be last added path
      export PATH=/opt/homebrew/bin:$PATH
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      # This will be first added path

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search=rg -p --glob '!node_modules/*'  $@

      # Emacs is my editor
      # export ALTERNATE_EDITOR=""
      # export EDITOR="emacsclient -t"
      # export VISUAL="emacsclient -c -a emacs"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';

    initExtra = ''
      eval "$(~/.local/bin/mise activate zsh)"'
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
