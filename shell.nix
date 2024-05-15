{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [ just pre-commit fd nixfmt ];
  shellHook = ''
    just hooks
  '';
}
