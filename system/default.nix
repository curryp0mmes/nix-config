{
  self,
  inputs,
  homeImports,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;

      username = "simon";

      # get these into the module system
      specialArgs = {
        inherit inputs self username;
      };

      # everything shared between all machines lives here,
      # machine specific stuff goes into ./hosts/<hostname>/default.nix
      mkHost =
        hostname:
        nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/${hostname}
            ./modules/systemd-boot.nix
            ./core-config.nix
            ./desktop-config.nix
            inputs.nix-easyroam.nixosModules.nix-easyroam
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.wuespace-plymouth.nixosModules.default

            {
              home-manager = {
                users.${username}.imports = homeImports.${username} ++ [
                  inputs.nixvim.homeModules.nixvim
                ];
                extraSpecialArgs = specialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        };
    in
    inputs.nixpkgs.lib.genAttrs [
      "garnix"
      "girlfriend-3"
      "ahornblatt"
    ] mkHost;
}
