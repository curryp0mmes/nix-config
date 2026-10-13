{ username, ... }:
{
  # steam must be installed globally
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # user level game launchers / emulators
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        prismlauncher
        dolphin-emu
      ];
    };
}
