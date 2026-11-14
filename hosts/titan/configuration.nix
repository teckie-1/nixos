{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];


  # UEFI assumed (modern desktop board) — confirm during install;
  # switch to boot.loader.grub if this board turns out to be BIOS-only.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  networking.hostName = "titan";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # AMD GPU — amdgpu is in-kernel and usually auto-loads, but enabling
  # graphics explicitly to be sure OpenGL/Vulkan userspace is wired up.
  hardware.graphics.enable = true;

  # Disable USB autosuspend
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  environment.systemPackages = [
    pkgs.mangohud
    pkgs.openrgb
    pkgs.hyperhdr
    pkgs.sbctl
    (pkgs.wrapOBS { plugins = [ pkgs.obs-studio-plugins.obs-vaapi ]; })
  ];
  hardware.i2c.enable = true;
  users.users.prime.extraGroups = [ "i2c" "wheel" "networkmanager" "dialout"];
  services.udev.packages = [ pkgs.openrgb pkgs.libfido2 ];

  services.input-remapper.enable = true;


  # Gaming-specific stuff (Steam, GameMode, Proton) belongs here too,
  # not in common.nix — add as needed.
  hardware.graphics.enable32Bit = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  home-manager.users.prime = { ... }: {
    xdg.configFile."MangoHud/MangoHud.conf".source = ../../dotfiles/MangoHud/MangoHud.conf;
  };
}
