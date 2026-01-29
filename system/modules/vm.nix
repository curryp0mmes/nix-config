{ config, pkgs, ... }:

let
  username = "simon"; # CHANGE THIS to your actual Linux username
in
{

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true; # optional, for TPM support
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_kvm
    OVMF
  ];
  
  users.groups.libvirtd.members = [ username ];

  virtualisation.spiceUSBRedirection.enable = true;
  
  # Add user to libvirt and kvm groups
  users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];

  # Ensure libvirt starts on boot
  services.spice-vdagentd.enable = true;
}
