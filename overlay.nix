final: prev:
let
  callPackage = prev.lib.callPackageWith prev;
  nixos-lib = import (prev.path + "/nixos/lib") { };
  runTest = nixos-lib.runTest;

  skiboot = callPackage ./skiboot { };
in
{
  power64-os = {
    inherit skiboot;
    checks.skiboot = runTest (import ./skiboot/test.nix {
      pkgs = final;
      inherit skiboot;
    });
  };
}
