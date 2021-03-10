{ config, lib, pkgs, stdenv, ... }:

let
  defaultPkgs = with pkgs; [
    asciinema            # record the terminal
    betterlockscreen     # fast lockscreen based on i3lock
    cachix               # nix caching
    dconf2nix            # dconf (gnome) files to nix converter
    docker-compose       # docker manager
    dive                 # explore docker layers
    gimp                 # gnu image manipulation program
    hyperfine            # command-line benchmarking tool
    insomnia             # rest client with graphql support
    killall              # kill processes by name
    libreoffice          # office suite
    libnotify            # notify-send command
    nix-doc              # nix documentation search tool
    nix-index            # files database for nixpkgs
    manix                # documentation searcher for nix
    pavucontrol          # pulseaudio volume control
    paprefs              # pulseaudio preferences
    pasystray            # pulseaudio systray
    pulsemixer           # pulseaudio mixer
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    signal-desktop       # signal messaging client
    slack                # messaging client
    tdesktop             # telegram messaging client
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)
    yad                  # yet another dialog - fork of zenity

    # fixes the `ar` error required by cabal
    binutils-unwrapped
  ];

  gnomePkgs = with pkgs.gnome3; [
    eog            # image viewer
    evince         # pdf reader
    gnome-calendar # calendar
    nautilus       # file manager
  ];

  haskellPkgs = with pkgs.haskellPackages; [
    brittany                # code formatter
    cabal2nix               # convert cabal projects to nix
    cabal-install           # package manager
    ghc                     # compiler
    haskell-language-server # haskell IDE (ships with ghcide)
    hoogle                  # documentation
    nix-tree                # visualize nix dependencies
  ];

  xmonadPkgs = with pkgs; [
    networkmanagerapplet   # networkmanager applet
#    nitrogen               # wallpaper manager
#    xcape                  # keymaps modifier
#    xorg.xkbcomp           # keymaps modifier
#    xorg.xmodmap           # keymaps modifier
#    xorg.xrandr            # display manager (X Resize and Rotate protocol)
  ];

in
{
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = p: {
      nur = import (import pinned/nur.nix) { inherit pkgs; };
    };
  };

  nixpkgs.overlays = [];

  imports = (import ./programs) ++ (import ./services) ++ [(import ./themes)];

  xdg.enable = true;

  home = {
    username      = "heyyou";
    homeDirectory = "/home/heyyou";
    stateVersion  = "20.09";

    packages = defaultPkgs ++ gnomePkgs ++ haskellPkgs ++ xmonadPkgs;

    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "nvim";
    };
  };

  # notifications about home-manager news
  news.display = "silent";

  programs = {
    fzf = {
      enable = true;
    };

    gpg.enable = true;

    htop = {
      enable = true;
      sortDescending = true;
      sortKey = "PERCENT_CPU";
    };

    jq.enable = true;
    ssh.enable = true;
  };

  services = {
    flameshot.enable = true;
  };
}

