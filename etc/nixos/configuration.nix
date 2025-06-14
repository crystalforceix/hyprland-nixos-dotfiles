{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # zen-kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.kernel.sysctl = {
    "vm.swappiness" = 60; 
    "vm.vfs_cache_pressure" = 50; 
    "vm.dirty_background_ratio" = 10;
    "vm.dirty_ratio" = 20;
    "kernel.sched_latency_ns" = 4000000;
    "kernel.sched_min_granularity_ns" = 500000;
    "kernel.sched_wakeup_granularity_ns" = 50000;
    "kernel.sched_migration_cost_ns" = 250000;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "kernel.sched_nr_migrate" = 128;
  };
  services.thermald.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
];

# For 32 bit applications 
hardware.graphics.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
];


  networking.hostName = "anhbaphu-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";

# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Bluetooth service
  hardware.bluetooth.enable = true;

  # Pipewire
  security.rtkit.enable = true;
    services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Zram
  zramSwap.enable = true;
  # Blueman service
  services.blueman.enable = true;


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anhbaphu = {
    isNormalUser = true;
    description = "anhbaphu-laptop";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # NixOS Package Manager
  environment.systemPackages = with pkgs; [
	
	# Apps
  	firefox
	nautilus
	blueman

	# Hyprland stuff
	kitty
	fuzzel
	fish
	pavucontrol
	brightnessctl
	waybar
	playerctl
	lm_sensors
	swaynotificationcenter
	xdg-desktop-portal-wlr
	wlogout
	pamixer
	swww
	nwg-look
	papirus-icon-theme
	clipse
	wl-clipboard
	hyprshot
	oh-my-posh
	hyprpicker
	waypaper
	hyprshade

	# Terminal app
	htop
	tlp  # Power manager
	neofetch
	git
	fcitx5-configtool
	libnotify
	tty-clock
	cmatrix

        # Neovim stuff
	neovim
	gnumake
	unzip
	gcc
	ripgrep
	fd
	
	# Visual Studio Code
	vscode

  ];


  # Environment fcitx5
  environment.variables = {
    INPUT_METHOD = "fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

   i18n.inputMethod.fcitx5.waylandFrontend = true;
   i18n.inputMethod = {
     type = "fcitx5";
     enable = true;
     fcitx5.addons = with pkgs; [
       fcitx5-gtk             # alternatively, kdePackages.fcitx5-qt
       fcitx5-unikey            # a color theme
     ];
   };

  # TLP

  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
};


  # Nautilus Trash Manager
  services.gvfs.enable = true;
  # Fonts manager
  fonts.packages = with pkgs; [ 
  	nerd-fonts.symbols-only
	nerd-fonts.departure-mono
];

  # Hyprland
  programs.hyprland.enable = true;

  # Hyprlock
  programs.hyprlock.enable = true;


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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
