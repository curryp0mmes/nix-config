{
  self,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "simon" = [
      ./home.nix
    ];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
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
