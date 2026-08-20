{ inputs, pkgs, ... }:
{
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };
  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];

  # Enable standard OpenSSH agent for FIDO2/ed25519-sk hardware key (Nitrokey) support
  programs.ssh.startAgent = true;

  # Disable gcr-ssh-agent which does not support FIDO2/ed25519-sk keys and conflicts with OpenSSH agent
  services.gnome.gcr-ssh-agent.enable = false;
}
