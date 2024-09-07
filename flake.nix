{
  description = "Base OS Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    erosanix.url = "github:emmanuelrosa/erosanix";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      auto-cpufreq,
      hyprland,
      erosanix,
      ...
    }:
    {
      nixosConfigurations.theodore = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit hyprland;
        };
        modules = [
          stylix.nixosModules.stylix
          erosanix.nixosModules.protonvpn
          ./configuration.nix
          home-manager.nixosModules.home-manager
          ./home.nix
          auto-cpufreq.nixosModules.default
        ];
      };
    };
}
