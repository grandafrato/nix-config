{
  description = "Base OS Nix flake";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:Nixos/nixpkgs/24.05";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
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
      nixvim,
      nix-hardware,
      hyprland,
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
            inherit inputs nixvim;
            stable-pkgs = nixpkgs-stable.legacyPackages.${system};
            hyprland-pkgs = hyprland.packages.${system};
          };
          modules = [
            {
              nix.settings = {
                substituters = [
                  "https://hyprland.cachix.org"
                  "https://cosmic.cachix.org/"
                ];
                trusted-public-keys = [
                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                  "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
                ];
              };
            }
            stylix.nixosModules.stylix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            ./home.nix
            nix-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          ];
        };
    };
}
