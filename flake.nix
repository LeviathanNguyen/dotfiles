{
    description = "Nixos config flake";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "nixpkgs/nixos-unstable";

        # Home manager
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Hyprland
        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            submodules = true;
        };

        # Hyprland plugins
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
        inherit (self) outputs;
    in {
        # NixOS configuration entrypoint
        nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
	            system = "x86_64-linux";
                specialArgs = { inherit inputs outputs; };
                modules = [
                    ./configuration.nix
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        homeConfigurations = {
            levi = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
                extraSpecialArgs = { inherit inputs outputs; };
                # Main configuration file
                modules = [
                    ./home.nix
                ];
            };
        };
    };
}
