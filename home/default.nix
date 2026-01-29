{
  self,
  inputs,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "simon" = [
      ./home.nix
    ];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  # get these into the module system
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "simon" = homeManagerConfiguration {
        modules = homeImports."simon" ++ [
          inputs.stylix.homeModules.stylix
        ];
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
