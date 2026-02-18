{ pkgs, ... }: {
  home.packages = with pkgs; [
    # basic shell utils
    just file fzf

    # vcs
    gitoxide
    jj-watch

    # replace coreutils with rust rewrite
    uutils-coreutils-noprefix

    # archives
    unzip gzip 

    # http & friends
    curl wget jq

    # extra nix helpers
    comma nix-tree

    # networking
    nmap inetutils cfspeedtest

    # other utilities
    tio # serial device tool
    gurk-rs # signal client
    pass gnome-keyring

    # asahi vm stuff
    distrobox

    # misc
    protonvpn-gui
    sl # steam locomotive
    typer # typing test
    fastfetch # rip neofetch :(
    spotify-player
  ];
  
  # replacement for `cat`
  programs.bat.enable = true;

  # system monitors
  programs.btop.enable = true;
  programs.bottom.enable = true;

  # replacement for `ls`
  programs.eza.enable = true;
  
  # replacement for `grep`
  programs.ripgrep.enable = true;

  services.bluehood = {
    enable = true;
    port = 9000;
    executable = "/run/wrappers/bin/bluehood";
  };
}
