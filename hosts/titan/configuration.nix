{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # UEFI assumed (modern desktop board) — confirm during install;
  # switch to boot.loader.grub if this board turns out to be BIOS-only.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "titan";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # AMD GPU — amdgpu is in-kernel and usually auto-loads, but enabling
  # graphics explicitly to be sure OpenGL/Vulkan userspace is wired up.
  hardware.graphics.enable = true;

  # Disable USB autosuspend
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Screen off after 5 min idle — no suspend/hibernate, so SSH stays reachable.
  environment.systemPackages = [ pkgs.swayidle ];
  systemd.user.services.swayidle = {
    description = "Idle manager — screen off after 5 min, no suspend";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 'niri msg action power-off-monitors' resume 'niri msg action power-on-monitors'";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  # Gaming-specific stuff (Steam, GameMode, Proton) belongs here too,
  # not in common.nix — add as needed.
}
