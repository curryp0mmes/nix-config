{ inputs, pkgs, ... }:
{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    # set custom source:
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Enable Hyprland cachix
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Enable Hyprlock
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };
 
  # Enable waybar
  programs.waybar.enable = true;


  # setup stuff for theming Plasma Apps 
  environment.systemPackages = with pkgs; [ qt6Packages.qt6ct ];
  environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
}
