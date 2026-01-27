{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "N_m3u8DL-RE-bin";

  # 1. UPDATE THIS to the latest version you see on GitHub
  version = "0.5.1-beta";
  date = "20251029";

  src = fetchurl {
    url = "https://github.com/nilaoda/N_m3u8DL-RE/releases/download/v${version}/N_m3u8DL-RE_v${version}_osx-arm64_${date}.tar.gz";

    # 2. Start with a fake hash to trigger the error that gives you the real one
    hash = "sha256-U3hm19A8mu0EyRABS86uJqPbSUwdHtrpxZ3aqimwocc=";
  };

  sourceRoot = ".";

  # Nix automatically unpacks tar.gz files. 
  # We just need to copy the binary to the right place.
  installPhase = ''
    runHook preInstall

    # Create the /bin directory in the Nix store
    mkdir -p $out/bin

    # The file inside the tar is just named "N_m3u8DL-RE"
    install -m755 N_m3u8DL-RE $out/bin/N_m3u8DL-RE

    runHook postInstall
  '';

  meta = with lib; {
    description = "N_m3u8DL-RE (Binary Build)";
    homepage = "https://github.com/nilaoda/N_m3u8DL-RE";
    platforms = [ "aarch64-darwin" ];
  };
}
