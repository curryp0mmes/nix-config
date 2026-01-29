{ pkgs, ... }:
{
  # Theme
  stylix = {
    enable = true;
    polarity = "dark";
    # Photo "asphalt road and cliff horizon" by Rory Hennessey on Unsplash: https://unsplash.com/photos/asphalt-road-and-cliff-horizon-PBrovES5uuI
    # See ./wallpapers/README.md
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # cursor = {
    #   package = pkgs.bibata-cursors;
    #   name = "Bibata-Modern-Classic";
    #   size = 32;
    # };
  };
}
