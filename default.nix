{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  digitalalovestory-bin = pkgs.pkgsi686Linux.callPackage ./pkgs/digitalalovestory-bin { };
}
