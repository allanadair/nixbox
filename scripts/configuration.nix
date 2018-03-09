{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vagrant.nix
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

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin.enable = true;
  services.xserver.displayManager.sddm.autoLogin.relogin = true;
  services.xserver.displayManager.sddm.autoLogin.user = "vagrant";
  services.xserver.desktopManager.plasma5.enable = true;

  # Replace nptd by timesyncd.
  services.timesyncd.enable = true;

  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  # Enable docker.
  virtualisation.docker.enable = true;

  fileSystems."/efs/servicedata" =
    {
      device = "gdo-servicedata.gdo.aws.:/servicedata/";
      fsType = "nfs";
    };

  fileSystems."/efs/sharedarcgis" =
    {
      device = "k8s-prod2-prereq-agsbackbone.gdo.aws.:/sharedarcgis/";
      fsType = "nfs";
    };

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
    (python27.withPackages(ps: with ps; [ pip virtualenv wheel jedi flake8 importmagic autopep8 yapf ]))
    (python36.withPackages(ps: with ps; [ pip wheel jedi flake8 importmagic autopep8 yapf ]))
    aws
    curlFull
    docker-edge
    emacs
    firefox
    gitAndTools.gitFull
    hunspell
    hunspellDicts.en-us
    nodejs-8_x
    p7zip
    plantuml
    tree
  ];

  # Users that are part of the wheel group will not be prompted for password
  security.sudo.wheelNeedsPassword = false;
  
  # Creates a "vagrant" users with password-less sudo access
  users = {
    extraGroups = [ { name = "vagrant"; } { name = "vboxsf"; } ];
    extraUsers  = [
      # Try to avoid ask password
      { name = "root"; password = "vagrant"; }
      {
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
      }
    ];
  };

}
