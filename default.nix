{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  digital-a-love-story = pkgs.pkgsi686Linux.callPackage ./pkgs/digital-a-love-story { };
  dont-take-it-personally-babe = pkgs.pkgsi686Linux.callPackage ./pkgs/dont-take-it-personally-babe { };
}
