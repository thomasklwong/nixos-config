{
  description = "Thomas Wong Configuration with secrets for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    
    # agenix.url = "github:ryantm/agenix";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    hashicorp-homebrew-tap = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };

    speedtest-homebrew-tap = {
      url = "github:teamookla/homebrew-speedtest";
      flake = false;
    };

    colmsg-homebrew-tap = {
      url = "github:proshunsuke/homebrew-colmsg";
      flake = false;
    };

    codexbar-homebrew-tap = {
      url = "github:steipete/homebrew-tap";
      flake = false;
    };




    # secrets = {
    #  url = "git+ssh://git@github.com/thomasklwong/nix-secrets.git";
    #  flake = false;
    # };

  };
  outputs = { 
    self, 
    darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    hashicorp-homebrew-tap,
    speedtest-homebrew-tap,
    colmsg-homebrew-tap,
    codexbar-homebrew-tap,
    home-manager,
    nixpkgs,
    nixpkgs-stable,
    /* agenix, */ 
    /* secrets */ ... 
  } @inputs:
    let
      user = "thomas";
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs darwinSystems f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };
      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nixpkgs.overlays = [
                (self: super: {
                  licensee = inputs.nixpkgs-stable.legacyPackages.${self.system}.licensee;
                })
              ];
              nix-homebrew = {
                inherit user;
                enable = true;
                enableRosetta = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "hashicorp/homebrew-tap" = hashicorp-homebrew-tap;
                  "teamookla/homebrew-speedtest" = speedtest-homebrew-tap;
                  "proshunsuke/homebrew-colmsg" = colmsg-homebrew-tap;
                  "steipete/homebrew-codexbar" = codexbar-homebrew-tap;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
      );


  };
}
