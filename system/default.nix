{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    # inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {
      inherit inputs self;
    };
  in {
              useGlobalPkgs = true;
              useUserPackages = true;
    garnix = nixosSystem {
        inherit specialArgs;
        modules = [
          ./devices/gigabyte/hardware-configuration.nix
          ./modules/systemd-boot.nix
          ./core-config.nix
          ./desktop-config.nix
          inputs.nix-easyroam.nixosModules.nix-easyroam
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix

          {
            home-manager = {
              users.simon.imports = homeImports."simon" ++ [
                inputs.nixvim.homeModules.nixvim
              ];
              extraSpecialArgs = specialArgs;
                  useGlobalPkgs = true;
                  useUserPackages = true;
            };
          }
        ];
    };

    girlfriend-3 = nixosSystem {
        inherit specialArgs;
        modules = [
          ./devices/thinkpad/hardware-configuration.nix
          ./modules/systemd-boot.nix
          ./core-config.nix
          ./desktop-config.nix
          inputs.nix-easyroam.nixosModules.nix-easyroam
          inputs.home-manager.nixosModules.home-manager
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2
          inputs.stylix.nixosModules.stylix

          {
            home-manager = {
              users.simon.imports = homeImports."simon" ++ [
                inputs.nixvim.homeModules.nixvim
              ];
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
  };
}
