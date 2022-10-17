{ config, lib, pkgs, nixpkgs, ... }:
with lib;
let
  gce = pkgs.google-compute-engine;
in
{

  # Include our configs and flake
  environment.etc = {
    nixos = {
      enable = true;
      source = builtins.path {
        name = "nixos-configuration";
        path = ../../.;
        filter = path: type: path != ../result;
      };
    };
  };

  boot.vesa = false;

  systemd.services."serial-getty@ttyS0".enable = true;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  # Being headless, we don't need a GRUB splash image.
  boot.loader.grub.splashImage = null;


  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" "virtio_scsi" ];

  boot.initrd.postDeviceCommands =
    ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      hwclock -s
    '';


  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
  };

  boot.growPartition = true;
  boot.kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
  boot.kernelModules = [ "virtio_pci" "virtio_net" ];

  # Generate a GRUB menu.
  boot.loader.grub.device = "/dev/sda";

  # Allow root logins only using SSH keys
  # and disable password authentication in general
  services.openssh.enable = mkDefault false;
  services.openssh.permitRootLogin = mkDefault "prohibit-password";
  services.openssh.passwordAuthentication = mkDefault true;

  # enable OS Login. This also requires setting enable-oslogin=TRUE metadata on
  # instance or project level
  security.googleOsLogin.enable = true;

  # Use GCE udev rules for dynamic disk volumes
  services.udev.packages = [ gce ];

  # Force getting the hostname from Google Compute.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  # Make sure GCE image does not replace host key that NixOps sets
  environment.etc."default/instance_configs.cfg".text = lib.mkDefault ''
    [InstanceSetup]
    set_host_keys = false
  '';

  # Rely on GCP's firewall instead
  networking.firewall.enable = mkDefault false;

  # Configure default metadata hostnames
  networking.extraHosts = ''
    169.254.169.254 metadata.google.internal metadata
  '';

  networking.timeServers = [ "metadata.google.internal" ];

  networking.usePredictableInterfaceNames = false;

  # GC has 1460 MTU
  networking.interfaces.eth0.mtu = 1460;

  systemd.services.google-instance-setup = {
    description = "Google Compute Engine Instance Setup";
    after = [ "network-online.target" "network.target" "rsyslog.service" ];
    before = [ "sshd.service" ];
    path = with pkgs; [ coreutils ethtool openssh ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_instance_setup";
      StandardOutput="journal+console";
      Type = "oneshot";
    };
    wantedBy = [ "sshd.service" "multi-user.target" ];
  };

  systemd.services.google-network-daemon = {
    description = "Google Compute Engine Network Daemon";
    after = [ "network-online.target" "network.target" "google-instance-setup.service" ];
    path = with pkgs; [ iproute2 ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_network_daemon";
      StandardOutput="journal+console";
      Type="simple";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.google-clock-skew-daemon = {
    description = "Google Compute Engine Clock Skew Daemon";
    after = [ "network.target" "google-instance-setup.service" "google-network-daemon.service" ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_clock_skew_daemon";
      StandardOutput="journal+console";
      Type = "simple";
    };
    wantedBy = ["multi-user.target"];
  };


  systemd.services.google-shutdown-scripts = {
    description = "Google Compute Engine Shutdown Scripts";
    after = [
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${gce}/bin/google_metadata_script_runner --script-type shutdown";
      RemainAfterExit = true;
      StandardOutput="journal+console";
      TimeoutStopSec = "0";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.google-startup-scripts = {
    description = "Google Compute Engine Startup Scripts";
    after = [
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_metadata_script_runner --script-type startup";
      KillMode = "process";
      StandardOutput = "journal+console";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.etc."sysctl.d/11-gce-network-security.conf".source = "${gce}/sysctl.d/11-gce-network-security.conf";

  formatAttr = "googleComputeImage";
}
