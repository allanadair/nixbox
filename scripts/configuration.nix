{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *. 
  boot.initrd.checkJournalingFS = false;

  networking = {
    nameservers = [
      "ns-1536.awsdns-00.co.uk"
      "ns-0.awsdns-00.com"
      "ns-1024.awsdns-00.org"
      "ns-512.awsdns-00.net"
    ];
  };

  # Services to enable:

  # Enable dbus.
  services.dbus.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "no-latin1";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "no";
  
  # Enable gnome desktop environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoLogin.enable = true;
  services.xserver.displayManager.gdm.autoLogin.user = "vagrant";
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Replace nptd by timesyncd.
  services.timesyncd.enable = true;

  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  # Enable docker.
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  fileSystems."/efs/servicedata" = {
      device = "gdo-servicedata.gdo.aws:/servicedata/";
      fsType = "nfs";
  };

  fileSystems."/efs/sharedarcgis" = {
      device = "k8sagsbackend.gdo.aws:/sharedarcgis/";
      fsType = "nfs";
  };

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Packages for Vagrant
  environment.systemPackages = with pkgs; [
    findutils
    gnumake
    iputils
    jq
    nettools
    netcat
    nfs-utils
    rsync
    curlFull
    docker
    firefox
    gnupg
    kubectl
    zile
  ];
  
  # Environment settings for guix
  environment.interactiveShellInit = ''
    export PATH="$PATH:/usr/local/bin";
    export INFOPATH="$INFOPATH:/usr/local/share/info";
    export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale";
  '';

  # Users that are part of the wheel group will not be prompted for password
  security.sudo.wheelNeedsPassword = false;
  
  # Creates a "vagrant" users with password-less sudo access
  users = {
    mutableUsers = false;

    extraGroups = [ { name = "vagrant"; } { name = "vboxsf"; } { name = "guixbuild"; } ];

    extraUsers =
      let
        vagrantUser = {
          vagrant = {
            description     = "Vagrant User";
            name            = "vagrant";
            group           = "vagrant";
            extraGroups     = [ "users" "vboxsf" "wheel" "docker" ];
            password        = "vagrant";
            home            = "/home/vagrant";
            createHome      = true;
            useDefaultShell = true;
            openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
            ];
          };
        };
        buildUser = (i:
          {
            "guixbuilder${i}" = {                   # guixbuilder$i
              group = "guixbuild";                  # -g guixbuild
              extraGroups = ["guixbuild"];          # -G guixbuild
              home = "/var/empty";                  # -d /var/empty
              shell = pkgs.nologin;                 # -s `which nologin`
              description = "Guix build user ${i}"; # -c "Guix buid user $i"
              isSystemUser = true;                  # --system
            };
          }
        );
      in
        # merge all users
        pkgs.lib.fold (str: acc: acc // buildUser str)
                      vagrantUser
                      # for i in `seq -w 1 10`
                      (map (pkgs.lib.fixedWidthNumber 2) (builtins.genList (n: n+1) 10));	
  };
  
  systemd = {
    services = {
      # Derived from Guix guix-daemon.service.in
      # https://git.savannah.gnu.org/cgit/guix.git/tree/etc/guix-daemon.service.in?id=00c86a888488b16ce30634d3a3a9d871ed6734a2
      guix-daemon = {
        enable = true;
        description = "Build daemon for GNU Guix";
        serviceConfig = {
          ExecStart = "/var/guix/profiles/per-user/root/guix-profile/bin/guix-daemon --build-users-group=guixbuild";
          Environment="GUIX_LOCPATH=/root/.guix-profile/lib/locale";
          RemainAfterExit="yes";
          StandardOutput="syslog";
          StandardError="syslog";
          TaskMax= "8192";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
