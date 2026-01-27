{ pkgs }:

with pkgs;
let
  # 1. Import your shared list as before
  shared-packages = import ../shared/packages.nix { inherit pkgs; };

  # 2. Define the path to your custom packages folder
  packagesDir = ./packages;

  # 3. Magic Function: Read directory -> Find .nix files -> callPackage them
  custom-packages = let
    # Read all files in the directory
    files = builtins.readDir packagesDir;
    
    # Filter: Keep only regular files that end with ".nix"
    nixFiles = builtins.filter
      (name: (files.${name} == "regular") && (lib.hasSuffix ".nix" name))
      (builtins.attrNames files);
      
  in
    # Map over the list of filenames and apply callPackage to each
    map (fname: callPackage (packagesDir + "/${fname}") { }) nixFiles;

in
# 4. Combine everything: Shared + Auto-Loaded + Manual Overrides
shared-packages ++ custom-packages ++ [
  # You can still add one-off official packages here manually if you want
  dockutil
  cocoapods
]
