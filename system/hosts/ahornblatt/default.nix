# ThinkPad T14s (no games, no wfb-rs)
{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/fingerprint.nix
    ../../modules/secure-boot.nix
    ../../modules/windows-dualboot.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
  ];

  # Windows (BitLocker) partition, unlocked and mounted on first access of /mnt/windows.
  # The key file holds the BitLocker password or recovery key, without a trailing newline:
  #   sudo install -Dm400 /dev/null /etc/secrets/bitlocker.key
  #   printf '%s' '<key>' | sudo tee /etc/secrets/bitlocker.key >/dev/null
  environment.etc.crypttab.text = ''
    windows UUID=2d897d0f-fd15-46fb-8b1c-bee81d71183b /etc/secrets/bitlocker.key bitlk,noauto,nofail
  '';
  fileSystems."/mnt/windows" = {
    device = "/dev/mapper/windows";
    fsType = "ntfs3";
    options = [
      "noauto"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
      "uid=1000"
      "gid=100"
      "windows_names"
    ];
  };

  # host specific home-manager settings
  home-manager.users.simon = {
    # rendered to ~/.config/niri-host/host.kdl, see home/modules/host-niri.nix
    host.niri = {
      outputs = {
        "eDP-1" = {
          mode = "1920x1200@60.001";
          scale = 1;
          position = {
            x = 0;
            y = 889;
          };
        };
        "Lenovo Group Limited T27QD-40 VNACY2AB" = {
          mode = "2560x1440@119.998";
          scale = 1;
          position = {
            x = 1920;
            y = 455;
          };
          focusAtStartup = true;
        };
        "Lenovo Group Limited T27Q-40 V90G3EEM" = {
          mode = "2560x1440@119.998";
          scale = 1;
          #transform = "90";
          position = {
            x = 4480;
            y = 455;
          };
        };
      };
      # autostart = [ "steam -silent" ];
    };
  };

  #fixing window manager not redrawing fully
  boot.kernelParams = [
    # "xe.enable_fbc=0"            # try this first
    # "xe.enable_psr=0"          # then this
    # "xe.enable_panel_replay=0" # DP-4/DP-6 may get Panel Replay too
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
