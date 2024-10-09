{
    description = "Nixos config flake";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

        # Home manager
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
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

        # Lix
        lix-module = {
            url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, ... }: 
    let
        # =====================================================================
        # ========================== SYSTEM SETTINGS ==========================
        # =====================================================================
        systemSettings = {
            system = "x86_64-linux";
            hostname = "nixos";
            timezone = "Asia/Ho_Chi_Minh";
            locale = "en_US.UTF-8";
            bootMode = "uefi";
            bootMountPath = "/boot";
            grubDevice = "";
            gpuType = "nvidia";
        };

        # =====================================================================
        # =========================== USER SETTINGS ===========================
        # =====================================================================
        userSettings = rec {
            username = "levi";
            name = "Leviathan Nguyen";
            email = "ductiennguyen74@gmail.com";
            dotfileDir = "~/.dotfiles/";
            theme = "";
            wm = "hyprland";
            wmType = "wayland";
            browser = "firefox";
            term = "kitty";
            font = "Intel One Mono";
            fontPkg = pkgs.intel-one-mono;
            editor = "nvim";
            spawnEditor = if ((editor == "vim") || (editor == "nvim") || (editor == "nano")) then
                            "exec " + term + " -e" + editor
                        else
                            editor;
        };

        lib = inputs.nixpkgs.lib;
        pkgs = import inputs.nixpkgs {
            system = systemSettings.system;
            config = {
                allowUnfree = true;
                allowUnfreePredicate = (_: true);
            };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
	    system = systemSettings.system;
	    config = {
	        allowUnfree = true;
		allowUnfreePredicate = (_: true);
	    };
	};
        home-manager = inputs.home-manager;
        supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
        forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
        nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
    in {
        # NixOS configuration entrypoint
        nixosConfigurations = {
            nixos = lib.nixosSystem {
                system = systemSettings.system;
                modules = [
                    ./configuration.nix
                    inputs.lix-module.nixosModules.default
                ];
                specialArgs = {
                    inherit pkgs-unstable;
                    inherit systemSettings;
                    inherit userSettings;
                    inherit inputs;
                };
            };
        };

        # Standalone home-manager configuration entrypoint
        homeConfigurations = {
            levi = home-manager.lib.homeManagerConfiguration {
                inherit pkgs-unstable;
                modules = [ ./home.nix ];
                extraSpecialArgs = {
       	 	    # inherit pkgs-unstable;
                    inherit systemSettings;
                    inherit userSettings;
                    inherit inputs;
                };
            };
        };
    };
}
