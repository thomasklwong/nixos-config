{ pkgs }:

with pkgs; [
  # Cannot use 1password via Nix App it seems
  # as it will complain it is not installed
  # at /Application
  _1password
  age
  aspell
  aspellDicts.en
  awscli2
  bat
  bento4
  btop
  cabextract
  cloc
  colima
  coreutils
  curlFull
  devenv
  difftastic
  docker
  docker-compose
  fd
  ffmpeg
  fzf
  htop
  imagemagickBig
  inetutils
  jq
  killall
  lz4
  pandoc
  python3
  qemu
  mise
  nmap
  ripgrep
  sqlite
  streamlink
  tailscale
  texliveSmall
  tree
  watch
  xz
  yt-dlp

  # Node.js and related global setup
  nodejs
  #corepack

  # Scanner
  # cdxgen
  trivy
  syft
  license-scanner
  askalono
  licensee
  cyclonedx-cli
  sbom-utility

  fclones
  rsync

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
