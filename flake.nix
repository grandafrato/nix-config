{
  description = "Base OS Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:Nixos/nixpkgs/24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    erosanix = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      stylix,
      hyprland,
      erosanix,
      nixvim,
      nix-hardware,
      ...
    }@inputs:
    {
      nixosConfigurations.theodore =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hyprland nixvim;
            stable-pkgs = nixpkgs-stable.legacyPackages.${system};
          };
          modules = [
            stylix.nixosModules.stylix
            erosanix.nixosModules.protonvpn
            hyprland.nixosModules.default
            ./configuration.nix
            home-manager.nixosModules.home-manager
            ./home.nix
            nix-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          ];
        };
    };
}
