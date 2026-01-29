{ pkgs, ... }:
{
  home.shellAliases = {
    upd = "sudo nix flake update --flake ~/nix";
    rb = "nh os switch ~/nix";
    mkhome = "nh home switch ~/nix";
    gc = "nix-collect-garbage --delete-older-than 14d -d && notify-send 'Nix Garbage Collector' 'Finished cleaning up old generations.'";

    # eza and zoxide
    ls = "eza";
    l = "eza -lah --total-size";
    ll = "eza -lah --total-size";
    tree = "eza --tree --git-ignore";
    cd = "z";

    # misc
    y = "yazi";
    h = "history";
    v = "nvim";
    vim = "nvim";
    vn = "cd /home/simon/nix && nvim";

    # network manager
    bayern = "nmcli con up @BayernWLAN";
    hotspot = "nmcli con up 'Connection Error'";
  };
}
