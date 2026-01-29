{
  networking.firewall.checkReversePath = false;
  # aditionall firewall settings
  networking.firewall = {
     allowedTCPPorts = [ 
      4222
      8080
      1935
      1985
      8554
      8889
     ]; # for NATS server
     allowedUDPPorts = [
       5600
       10080
        8889
    #   14550
    #   5001
    #   67
     ]; # 1. RHD 2. MavLink 3. RODOS 4. dhcp server
    # checkReversePath = "loose"; # for tailscale
  };
}
