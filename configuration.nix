# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/backup" =
    { device = "/dev/disk/by-uuid/907294bd-7e64-424a-b335-41b5e58df1db";
      fsType = "ext4";
    };

  fileSystems."/mnt/extrastorage" =
    { device = "/dev/disk/by-uuid/bd4121cc-e6d5-4b80-bcda-743c6e7399df";
      fsType = "ext4";
    };    


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Bluetooth
 # hardware = {
 #     bluetooth = {
 #         enable = true;
 #         settings.General.Experimental = true;
 #     };
 # };

  services.restic.backups = {
    localbackup = {
      initialize = true;
      passwordFile = "/home/gasdia73/Documents/.restic";
      paths = [
          "/etc/group"
          "/etc/machine-id"
          "/etc/NetworkManager/system-connections"
          "/etc/passwd"
          "/etc/subgid"
          "/home"
          "/root"
          "/var/lib"
      ];
      repository = "/mnt/backup/restic-repo";
      timerConfig = {
        OnCalendar = "13:00";
      }; 
      pruneOpts = [
        "--keep-last 7"
      ];
    };
  };

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


# ------------nvidia stuff----

# Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.modesetting.enable = true;
# # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
#     # Enable this if you have graphical corruption issues or application crashes after waking
#     # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
#     # of just the bare essentials.
  hardware.nvidia.powerManagement.enable = false;
# # Fine-grained power management. Turns off GPU when not in use.
#     # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  hardware.nvidia.powerManagement.finegrained = false;
# # Use the NVidia open source kernel module (not to be confused with the
#     # independent third-party "nouveau" open source driver).
#     # Support is limited to the Turing and later architectures. Full list of 
#     # supported GPUs is at: 
#     # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
#     # Only available from driver 515.43.04+
#     # Currently alpha-quality/buggy, so false is currently the recommended setting.
  hardware.nvidia.open = false;
# # Enable the Nvidia settings menu,
# 	# accessible via `nvidia-settings`.
  hardware.nvidia.nvidiaSettings = true;
# # Optionally, you may need to select the appropriate driver version for your specific GPU.
   hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;


#-----------------------------


  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "14:00" ]; # Optional; allows customizing optimisation schedule


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     beep
     #openjdk16-bootstrap     
     jdk17
     sbt
     scala
     bloop
     metals
     vscode-extensions.scalameta.metals
     #coursier
     maven
     gitFull
     wget
     curl     
     google-chrome
     chromium
     unzip
     vscode
     jetbrains.idea-community
     obs-studio
     inetutils
     google-cloud-sdk
     (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.cloud-sql-proxy])
     pgadmin4
     nodejs_22
     gparted
     mongodb-compass
     soapui
     #insomnia
     #vlc
     #postgresql
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
  ];

#  nixpkgs.config.cudaSupport = true;

  services.flatpak.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.4.8248"
    "googleearth-pro-7.3.6.9796"
  ];


  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
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
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
