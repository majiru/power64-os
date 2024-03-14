{
  description = "POWER64 os dev environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    flake-utils.lib.simpleFlake
      {
        inherit self nixpkgs;
        name = "power64-os";
        overlay = ./overlay.nix;
      };
}
