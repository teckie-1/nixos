{ pkgs, ... }:

{
    services.printing = {
        enable = true;
        drivers = with pkgs; [ gutenprint hplip ];
      };

    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      hardware.sane = {
          enable = true;
          extraBackends = [ pkgs.sane-airscan ];
        };

      environment.systemPackages = [ pkgs.system-config-printer pkgs.simple-scan ];
  }
