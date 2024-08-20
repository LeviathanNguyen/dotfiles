{ config, pkgs, ... }:

{
    imports = [
        ./sh.nix
    ];
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "levi";
    home.homeDirectory = "/home/levi";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" "IntelOneMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
        neofetch
        nnn # terminal file manager
        gh

        # Archives
        zip
        xz
        unzip
        p7zip

        # Utilities
        ripgrep     # recursive searches directories for a regex pattern
        jq          # lightweight and flexible command-line JSON processor
        eza         # a modern replacement for `ls`
        fzf         # a command-line fuzzy finder
        bat         # replacement of `cat`

        # Networking tools
        mtr         # a network diagnostic tool
        iperf3      # network bandwidth measurement tool
        aria2       # a lightweight multi-protocol & multi-source command-line download utility
        nmap        # a utility for network discovery and security auditing
        ipcalc      # a calculator for the IPv4/v6 addresses

        # Misc
        file
        which
        gnused
        gnutar
        gnupg
        zstd
        flameshot

        # Nix relative
        nix-output-monitor

        # Productivity
        glow        # markdown previewer in terminal

        btop        # replacement of htop/nmon
        iotop       # I/O monitoring
        iftop       # network monitoring

        # System call monitoring
        strace      # system call monitoring
        ltrace      # library call monitoring
        lsof        # list open files

        # System tools
        sysstat
        lm_sensors  # for `sensors` command
        ethtool
        pciutils    # lspci
        usbutils    # lsusb

        # Login Manager
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/levi/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
      EDITOR = "vim";
    };
    
    # programs.flameshot = {
    #     enable = true;
    #     setting.General = {
    #         showStartupLaunchMessage = false;
    #         saveLastRegion = true;
    #     };
    # };
  
    # Github
    programs.git = {
        enable = true;
        userName = "LeviathanNguyen";
        userEmail = "levianth74@gmail.com";
        aliases = {
            pu = "push";
            co = "checkout";
            cm = "commit";
        };
        extraConfig = {
            init.defaultBranch = "main";
            safe.directory = [
                ("/home/levi/.dotfiles")
                ("/home/levi/.dotfiles/.git")
            ];
            credential.helper = "${
                pkgs.git.override { withLibsecret = true; }
            }/bin/git-credential-libsecret";
        };
        lfs.enable = true;
    };

    programs.gh = {
        enable = true;
    };

    # BTOP
    programs.btop.enable = true;

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
}
