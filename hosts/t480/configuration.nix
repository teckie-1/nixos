{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # NVMe + UEFI on this machine.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "t480";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Lock on lid close instead of suspending, so SSH/remote access stays up.
  services.logind.settings.Login.HandleLidSwitch = "lock";
}
