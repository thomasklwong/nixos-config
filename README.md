# Thomas Wong Nix Config for macOS + NixOS

Derived from https://github.com/dustinlyons/nixos-config/

## Naming on nix-homebrew

Ref: https://github.com/zhaofengli/nix-homebrew/issues/15#issuecomment-2133998831

In `flake.nix`

`inputs` section

```nix
    inputs = {
        # Other definitions
        <tap-name> = {
            url = "github:owner/repo-name";
            flake = false;
        };
    }
```

`outputs` sections

```
    outputs = {
        # Other stuff
         homebrew-cask,
         <tap-name>,
         # Other stuff
    } @inputs:
```

`darwinConfigurations` section

```nix
    darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
            # Other stuff
            modules = [
                nix-homebrew.darwinModules.nix-homebrew
                {
                    nix-homebrew = {
                        # Other stuff
                        taps = {
                            "homebrew/homebrew-bundle" = homebrew-bundle;
                            "<owner>/<repo-name>" = <tap-name>;
                        };
                    };
                }
            ];
        }
    );
```
