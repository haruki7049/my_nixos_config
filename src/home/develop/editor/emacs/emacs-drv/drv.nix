{ pkgs }:

pkgs.emacs-gtk.overrideAttrs (oldAttrs: {
  withX = true;
  withAlsaLib = true;
})
