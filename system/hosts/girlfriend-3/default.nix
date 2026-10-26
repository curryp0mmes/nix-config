# ThinkPad T14 AMD Gen 2
{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/gaming.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2
    inputs.wfb-rs.nixosModules.default
  ];

  # host specific home-manager settings
  home-manager.users.simon = {
    # rendered to ~/.config/niri-host/host.kdl, see home/modules/host-niri.nix
    host.niri = {
      outputs = {
        "eDP-1" = {
          mode = "1920x1080@60.008";
          scale = 1;
          position = {
            x = 0;
            y = 0;
          };
          focusAtStartup = true;
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60.0";
          scale = 1;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };
      autostart = [ "xdg-open 'obsidian://open?vault=todos-and-personal&file=TODOs%20September%202026'" ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
