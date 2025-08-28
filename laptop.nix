{ config, pkgs, lib, ... }:

{
  # Set AMD CPU frequency scaling driver
  boot.kernelParams = [ "amd_pstate=active" ];

  services = {
    # Enable thermald (Intel CPUs only)
    thermald.enable = true;

    # Enable power-profiles-daemon (used by GNOME to switch power modes)
    power-profiles-daemon.enable = true;

    # Optional: Enable upower (used by GNOME for battery and power info)
    upower.enable = true;

    logind = {
      # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend", "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"
      settings.Login.HandleLidSwitchDocked = "ignore";
      settings.Login.HandleLidSwitchExternalPower = "lock";
      settings.Login.HandleLidSwitch = "hibernate";
    };

    # https://asus-linux.org/guides/nixos/
    # Enable supergfxctl service
    supergfxd.enable = true;

    # Enable asusd service (for ASUS-specific controls)
    asusd = {
      enable = true;
      enableUserService = true;
    };

  };
  # systemd.services.supergfxd.path = [ pkgs.pciutils ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # specialisation = {
  #   nvidia.configuration = {
  #     # Nvidia Configuration
  #     services.xserver.videoDrivers = [ "nvidia" ];
  #     hardware.graphics.enable = true;
  #
  #     # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #     hardware.nvidia.package =
  #       config.boot.kernelPackages.nvidiaPackages.stable;
  #
  #     # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  #     hardware.nvidia.modesetting.enable = true;
  #
  #     hardware.nvidia.prime = {
  #       sync.enable = true;
  #
  #       # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
  #       nvidiaBusId = "PCI:1:0:0";
  #
  #       # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
  #       intelBusId = "PCI:0:2:0";
  #     };
  #   };
  # };

}
