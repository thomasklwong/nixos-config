{ pkgs }:

with pkgs; [
  _1password
  _1password-gui
  age
  alacritty
  aspell
  aspellDicts.en
  awscli2
  bat
  btop
  cabextract
  colima
  coreutils
  devenv
  docker
  docker-compose
  fd
  ffmpeg
  fzf
  gh
  htop
  jq
  killall
  lz4
  nodejs
  python3
  qemu
  ripgrep
  sqlite
  streamlink
  tailscale
  tree
  watch
  xz
  yt-dlp

  # bash-completion
  # neofetch
  # openssh
  # wget
  # zip

  # Encryption and security tools
  
  # age-plugin-yubikey
  # gnupg
  # libfido2

  # Media-related packages
  # emacs-all-the-icons-fonts
  # dejavu_fonts
  # font-awesome
  # hack-font
  # noto-fonts
  # noto-fonts-emoji
  # meslo-lgs-nf

  # Node.js development tools
  # nodePackages.npm # globally install npm
  # nodePackages.prettier
  # nodejs

  # Text and terminal utilities
  # hunspell
  iftop
  # tmux
  # unrar
  # unzip
  # zsh-powerlevel10k

  # Python packages
  # python39
  # python39Packages.virtualenv # globally install virtualenv
]
