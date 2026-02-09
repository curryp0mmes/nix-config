{
  services.easyroam = {
      enable = true;
      pkcsFile = "/home/simon/.config/easyroam/antoherlinux.p12"; # or e.g. config.sops.secrets.easyroam.path
      # automatically configure wpa-supplicant (use this if you configure your networking via networking.wireless)
      wpa-supplicant = {
          enable = false;
          # optional, extra config to write into the wpa_supplicant network block
          # extraConfig = '';
          #    priority=5
          # '';
      };
      # automatically configure NetworkManager
      networkmanager = {
          enable = true;
          # optional, extra config to write into the NetworkManager config
          # extraConfig = {
          #    ipv6.addr-gen-mode = "default";
          # };
      };
      # optional, if you want to override the passphrase for the private key file.
      # this doesnt need to be secret, since its useless without the private key file
      # privateKeyPassPhrase = "";
      # optional, if you want to override where the extracted files end up
      # the defaults are:
      # /run/easyroam/common-name/
      # /run/easyroam/root-certificate.pem
      # /run/easyroam/client-certificate.pem
      # /run/easyroam/private-key.pem
      #
      # you can also read these from within your nix config using
      # `config.services.easyroam.paths`
      # paths = {
      #   rootCert = "";
      #   clientCert = "";
      #   privateKey = "";
      #   commonName = "";
      # };
      # optional, (permission bits) the files are stored as, (default is 0400 (0r--------))
      # mode = "";
      # optional, owner and group of the files. (default is root)
      # owner = "";
      # group = "";
  };
}
