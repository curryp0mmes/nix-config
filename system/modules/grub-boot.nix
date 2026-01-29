{ inputs, pkgs, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      version = 2;
      # IMPORTANT: Set this to the correct device where you want GRUB installed
      device = "/dev/nvme0n1"; # Example: Change to /dev/nvme0n1 or similar
      # Optional: Enable themes for better looks
      themes = [
        (pkgs.callPackage (
          # A popular theme for a modern look
          { grub2-theme, stdenv, lib }:
          grub2-theme {
            pname = "grub2-theme-tela";
            src = pkgs.fetchurl {
              url = "https://github.com/vinceliuice/Tela-grub-theme/releases/download/v1.0/Tela.tar.xz";
              hash = "sha256-R/J2qI0I1H93z/oV/N7d/T/S0gD9X/9z/w/A=";
            };
          }
        ) {})
      ];
    };
  };
  boot.plymouth = {
    enable = true;
  };
  boot.kernelParams = [ "quiet" "splash" "vt.global_cursor_default=0" ];
}
