{
  description = "Simons NixOS Configuration";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ ./home ./system ];
    };

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-easyroam.url = "github:0x5a4/nix-easyroam/592540d50149d5ccc2e2ff5105d141ed710dad57";

    affinity-nix.url = "github:mrshmllow/affinity-nix";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
