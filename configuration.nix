# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
    imports = [ 
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = false;
    boot.loader.efi.efiSysMountPoint = "/boot";

    networking.hostName = "nixos"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Set your time zone.
    time.timeZone = "Asia/Ho_Chi_Minh";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.inputMethod = {
        enable = true;
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
            bamboo
        ];
    };
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    #  };

    # Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" "nvidia" ];
    };

    services.displayManager.sddm.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
    #   options = "eurosign:e,caps:escape";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire
    # hardware.pulseaudio.enable = true;
    # OR
    # sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.levi = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "input" ];
        packages = with pkgs; [
            firefox
            tree
        ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Set ZSH as the default shell
    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        curl
        # Packages for Hyprland (change later)
        (waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        }))
        dunst
        libnotify
        swww
        networkmanagerapplet
        kitty
        rofi-wayland
        home-manager
        lshw-gui
    ];

    # Set the default editor to vim
    environment.variables.EDITOR = "vim";

    environment.sessionVariables = {
        # If your cursor becomes invisible
        WLR_NO_HARDWARE_CURSORS = "1";
        # Hint electron apps to use Wayland
        NIXOS_OZONE_WL = "1";
    };

    hardware = {
        # Enable graphics support
        graphics.enable = true;

        # Most Wayland compositors need this
        nvidia.modesetting.enable = true;

        # Enable Bluetooth support
        bluetooth = {
            enable = true;
            powerOnBoot = true;
        };

        enableAllFirmware = true;

        nvidia.prime = {
            offload.enable = true;
            amdgpuBusId = "PCI:5:0:0";
            nvidiaBusId = "PCI:1:0:0";
        };
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.mtr.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

    # Enable XDG portal
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # Power Management
    powerManagement.enable = true;
    services.tlp.enable = true;

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        settings = {
            X11Forwarding = true;
            PermitRootLogin = "no"; # disable root login
            PasswordAuthentication = true; # enable password login
        };
        openFirewall = true;
    };

    # SSD Optimization
    services.fstrim.enable = true;

    # Enable Bluetooth support
    services.blueman.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "24.05"; # Did you read the comment?

    # Enable experimental features in NixOS
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
    };
}
