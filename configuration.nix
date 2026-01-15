# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./vm.nix      
    ];

  # Enable networking
  networking.networkmanager.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #enable wifi dongle
  # hardware.usbWwan.enable = true;

  hardware.usb-modeswitch.enable=true;
  hardware.enableAllFirmware = true;
# Bluetooth
  hardware.bluetooth.enable = true;


#   hardware = {
#       bluetooth = {
#          enable = true;
#          powerOnBoot = true;
#          settings.General = {
#            Experimental = true;
#            Name = "Bluetooth dongle";
#            FastConnectable = true;
#            ControllerMode = "dual";
#          };
#          settings.Policy = {
#            AutoEnable = true;
#          };
# #         settings.General.Enable = "Source,Sink,Media,Socket";      
#       };
#   };



  services.ratbagd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  #prova startx command line prompt
  # services.xserver.autorun = false;
  # services.xserver.displayManager.startx.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "it";
    xkb.variant = "";
  };

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;




#-----------------------------


  # Configure console keymap
  console.keyMap = "it2";

  #Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #printing: attempt n. 2
  # services.printing.enable = true;
  # services.printing.drivers = [ pkgs.gutenprint ];  
  # services.printing.browsing = true;
  # services.printing.browsedConf = ''
  # BrowseDNSSDSubTypes _cups,_print
  # BrowseLocalProtocols all
  # BrowseRemoteProtocols all
  # CreateIPPPrinterQueues All
  
  # BrowseProtocols all
  #     '';
  # services.avahi = {
  #   enable = true;
  #   nssmdns = true;
  # };  

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gasdia73 = {
    isNormalUser = true;
    description = "gasdia73";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.bluedevil
      kdePackages.filelight
    #  thunderbird
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "yes"; # disable root login with no
      PasswordAuthentication = true; # disable password login
    };
    openFirewall = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.max-jobs = 2;

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "14:00" ]; # Optional; allows customizing optimisation schedule
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 50d";
  };
  nix.settings.auto-optimise-store = true;  

# List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     beep
     #openjdk16-bootstrap     
    #  jdk17
     jdk25
     javaPackages.openjfx25
     ant
     sbt
     scala
     bloop
     metals
     vscode-extensions.scalameta.metals
     scala-cli
     #coursier
     maven
     gitFull
     wget
     curl     
     jq
     google-chrome
     chromium
     unzip
     vscode
     jetbrains.idea-oss
     obs-studio
     inetutils
     google-cloud-sdk
     (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.cloud-sql-proxy])
     pgadmin4
     nodePackages_latest.nodejs
     gparted
     mlocate
     mongodb-compass
     soapui
     #insomnia
     vlc
     libvlc
     postgresql
    #  (blender.override { cudaSupport = true; })
     gimp
     inkscape
     rsync
     guvcview
     ntfs3g
     googleearth-pro
     logiops
     lsof
     usbutils
     speechd
     direnv
     nix-direnv
     nix-index
     appimage-run
     restic
     piper
     libinput
#     blender
#     redisinsight
     ffmpeg
     gst_all_1.gstreamer
     # Common plugins like "filesrc" to combine within e.g. gst-launch
     gst_all_1.gst-plugins-base
     # Specialized plugins separated by quality
     gst_all_1.gst-plugins-good
     gst_all_1.gst-plugins-bad
     gst_all_1.gst-plugins-ugly
     # Plugins to reuse ffmpeg to play almost every video format
     gst_all_1.gst-libav
     # Support the Video Audio (Hardware) Acceleration API
     gst_all_1.gst-vaapi
     v4l-utils
     nixd
     lm_sensors
     busybox
     xorg.xkill
     openssl
     usb-modeswitch
     usb-modeswitch-data
     libreoffice-qt
     vdhcoapp
     llvm
     clang
     redisinsight
     mongodb-compass
     httpie
     remmina
     ocrfeeder
     cmake
     cmakeWithGui
     openfortivpn
     subversion
     subversionClient
     #virtualboxWithExtpack - non installarlo -> conflitta con kvm
     dnsmasq
     qtscrcpy
     vdhcoapp #don't forget to reinstall after every upgrade
     protobuf_29
     slack
     #globalprotect-openconnect
     networkmanager-openconnect
     openconnect
     xclip
     python3
     dbeaver-bin
     
     home-manager

    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: 
        # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
        # lacking many basic packages needed by most software.
        # Therefore, we need to add them manually.
        #
        # pkgs.appimageTools provides basic packages required by most software.
        (base.targetPkgs pkgs) ++ (with pkgs; [
          pkg-config
          ncurses
          # Feel free to add more packages here if needed.
        ]
      );
      profile = "export FHS=1";
      runScript = "bash";
      extraOutputsToInstall = ["dev"];
    }))

    hplipWithPlugin

  ];

#  nixpkgs.config.cudaSupport = true;

  services.flatpak.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
    #"qtwebengine-5.15.19"
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    #trying to make swarm work
    liveRestore = false;
    
    # docker rootless prevents swarm from working 
    # https://forums.docker.com/t/running-docker-swarm-in-rootless-mode/136492

    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };

  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };

  services.postgresql = {
    enable = true;
    settings.port = 5434;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
	local all all              trust
  	host  all all 127.0.0.1/32 trust
  	host  all all ::1/128      trust
    '';
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  programs.kdeconnect.enable = true; 


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
