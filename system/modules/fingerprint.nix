{ ... }:
{
  # Fingerprint reader via fprintd (enroll with `fprintd-enroll`).
  # Enabling fprintd turns on pam_fprintd for every PAM service (sudo, polkit, ...):
  # touch the sensor, or press Ctrl+C / wait for the timeout to fall back to the password.
  services.fprintd.enable = true;

  security.pam.services = {
    # noctalia's lock screen authenticates against "login" and drives the reader itself
    # over D-Bus, so pam_fprintd must not be in this stack (they can't share the sensor)
    login.fprintAuth = false;
    # only the greeter session uses this stack now (logins go through greetd-autologin)
    greetd.fprintAuth = false;
  };
}
