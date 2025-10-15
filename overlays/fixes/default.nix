# overlays/fixes/default.nix
stable-pkgs-input: self: super: {
  licensee = (import stable-pkgs-input { system = self.system; }).licensee;
}
