{
  config,
  pkgs,
  username,
  ...
}:
let
  sessionCommand = "zsh -lc 'niri-session'";

  # greetd's own autologin (initial_session) skips pam_authenticate, so no password ever
  # reaches pam_gnome_keyring. This greeter logs in over greetd's IPC socket instead,
  # which runs the full PAM stack of the "greetd-autologin" service below.
  autologin-greeter = pkgs.writers.writePython3Bin "greetd-autologin" { } ''
    import json
    import os
    import socket
    import struct
    import sys

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(os.environ["GREETD_SOCK"])


    def request(req):
        body = json.dumps(req).encode()
        sock.sendall(struct.pack("=I", len(body)) + body)
        (length,) = struct.unpack("=I", sock.recv(4, socket.MSG_WAITALL))
        resp = json.loads(sock.recv(length, socket.MSG_WAITALL))
        if resp["type"] == "error":
            sys.exit("greetd: " + resp["description"])
        return resp


    resp = request({"type": "create_session", "username": "${username}"})
    # nothing in the stack prompts, but answer anyway so a stray
    # prompt can't hang the boot
    while resp["type"] == "auth_message":
        resp = request({"type": "post_auth_message_response", "response": None})
    request({
        "type": "start_session",
        "cmd": [${builtins.toJSON sessionCommand}],
        "env": [],
    })
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      general.service = "greetd-autologin";
      default_session = {
        command = "${autologin-greeter}/bin/greetd-autologin";
        # the greeter itself keeps the regular stack
        service = "greetd";
      };
    };
  };

  # Like GDM's gdm-autologin: no password check, but pick up the LUKS passphrase that
  # systemd-cryptsetup caches in the kernel keyring (for ~2.5 min) and hand it to
  # gnome-keyring. Only unlocks the keyring if its password matches the LUKS passphrase;
  # otherwise (no LUKS, key expired after a logout) the keyring just stays locked.
  # Relies on boot.initrd.systemd and greetd's KeyringMode=shared.
  security.pam.services.greetd-autologin.text = ''
    auth     optional  ${config.systemd.package}/lib/security/pam_systemd_loadkey.so
    auth     optional  ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
    auth     required  ${config.security.pam.package}/lib/security/pam_permit.so
    account  include   login
    password required  ${config.security.pam.package}/lib/security/pam_deny.so
    session  include   login
  '';
}
