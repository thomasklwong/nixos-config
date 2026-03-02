# overlays/fixes/default.nix
stable-pkgs-input: self: super: {
  licensee = (import stable-pkgs-input { system = self.system; }).licensee;
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      jeepney = python-prev.jeepney.overridePythonAttrs (oldAttrs: {
        doCheck = false;
        doInstallCheck = false;
        checkPhase = "";
        installCheckPhase = "true";
        pythonImportsCheck = [];
      });
    })
  ];
}
