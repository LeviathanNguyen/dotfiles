{ config, pkgs, ... }:

let
    myAliases = {
        ll = "eza -";
        ".." = "cd ..";
    };
in
{
    programs.bash = {
        enable = false;
        shellAliases = myAliases;
    };

    programs.zsh = {
        enable = true;
        shellAliases = myAliases;
    };
}
