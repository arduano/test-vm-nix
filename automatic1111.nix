{ config, lib, pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "AUTOMATIC1111";
    repo = "stable-diffusion-webui";
    rev = "v1.7.0";
    sha256 = "sha256-xOId/D5eJszmRn0tCZtS+/u5WQUBpdPQ0I5XZIv3FvE=";
  };

  automatic1111 = (pkgs.buildFHSEnv rec {
    name = "automatic1111-webui-env";
    targetPkgs = pkgs: (with pkgs; [
      git # The program instantly crashes if git is not present, even if everything is already downloaded
      python310
      stdenv.cc.cc.lib
      stdenv.cc
      ncurses5
      binutils
      gitRepo
      gnupg
      autoconf
      curl
      procps
      gnumake
      util-linux
      m4
      gperf
      unzip
      libGLU
      libGL
      glib
    ]);

    # LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath targetPkgs;

    # multiPkgs = pkgs: (with pkgs; [
    #   udev
    #   alsa-lib
    # ]);

    runScript = "${src}/webui.sh";
  });
in

{
  environment.systemPackages = [
    automatic1111
  ];
}
