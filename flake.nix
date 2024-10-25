{
  description = "Base OS Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
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
    zed-editor = {
      url = "github:zed-industries/zed";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      auto-cpufreq,
      hyprland,
      erosanix,
      zed-editor,
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
            inherit inputs;
            inherit hyprland;
            zedPackages = zed-editor.packages.${system};
          };
          modules = [
            stylix.nixosModules.stylix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            ./home.nix
            auto-cpufreq.nixosModules.default
            erosanix.nixosModules.protonvpn
          ];
        };
    };
}
