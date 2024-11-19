{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
}: let
  pname = "fm_transmitter";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "markondej";
    repo = pname;
    rev = "ae7d02eedba8bc9dac8ed843c070033098f7a451";
    sha256 = "sha256-bDkhqVFsOLh2g9wC2nM3awvrU3bvvdTuIMj/JWnGXCU=";
  };

  stdenv = pkgs.gcc10Stdenv;
in
  stdenv.mkDerivation {
    inherit pname version src;

    buildInputs = with pkgs; [
      libraspberrypi
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp ./fm_transmitter $out/bin/
    '';
  }
