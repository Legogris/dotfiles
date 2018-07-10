# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices = [
      {
        name = "strength-root";
        device = "/dev/disk/by-uuid/86ce90b6-9dfc-40b1-9ac0-400068f882ff";
        preLVM = true;
        allowDiscards = true;
      }
    ];
    kernelModules = [ "af_key" ];
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];


  networking = {
      hostName = "strength"; # Define your hostname.
      networkmanager = {
        enable = true;
        # enableStrongSwan = true;
      };
      # Open ports in the firewall.
      # firewall.allowedTCPPorts = [ ... ];
      # firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # firewall.enable = false;
  };

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Lat2-Terminus24";
     consoleKeyMap = "us";
     defaultLocale = "en_DK.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig.dpi = 120;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      dejavu_fonts
      powerline-fonts
      ubuntu_font_family
      terminus_font
    ];
  };

  time.timeZone = "Europe/Paris";

  nixpkgs.config = {
    # allowBroken = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
    };
    chromium = {
      # enableWideVine = true; # broken for now
      enablePepperFlash = false;
      enablePepperPdf = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    inetutils
    exfat
    sshfsFuse
    strongswan
    nix-repl
    terminus_font terminus_font_ttf material-icons font-awesome_5

    # Libs
    libnl # maybe need for freeswan vpn? not sure
    ike ipsecTools # maybe need for freeswan vpn? not sure. Added after libnl
    imagemagick
    ffmpeg
    libnotify 
    zlib
    openssl
    glibc glibcLocales glibcInfo

    # Cli
    zsh oh-my-zsh nix-zsh-completions lambda-mod-zsh-theme
    vimHugeX htop iotop jq lsof man_db psmisc tmux tree which file ncdu
    wget curl
    zip unzip unrar
    nmap
    gnupg

    # Dev and devops
    docker
    awscli packer
    gitAndTools.gitFull gitAndTools.hub
    stdenv gcc gnumake automake autoconf
    ruby_2_5
    binutils-unwrapped
    python27Full python3
    #python34Packages.pip
    #python27Packages.pip
    nodePackages.node2nix
    nodejs-8_x
    pass
    android-udev-rules

    # X11 / GTK / QT / desktop stuff
    xclip xlibs.xbacklight xlibs.xmodmap xlibs.xset xsel xtitle xkblayout-state
    xorg.xkill
    lxappearance-gtk3 nixos-icons xfce.xfce4-icon-theme
    gnome3.gtk glib gnome3.dconf gsettings-desktop-schemas
    deepin.deepin-gtk-theme deepin.deepin-icon-theme
    scrot 
    i3 wpa_supplicant_gui feh xorg.xbacklight i3status-rust dunst slim
    rxvt_unicode-with-plugins 

    # X applications
    networkmanagerapplet
    pavucontrol
    firefox chromium
    thunderbird
    keepassxc 
    qtpass
    keybase keybase-gui kbfs
    gimp
    meld
    vlc
    evince
    transmission_gtk
    skype
    spotify
    unstable.slack
    unstable.vscode
    unstable.gitkraken
    dotnet-sdk
  ];

  services = {
    xserver = {
      serverFlagsSection = ''
        Option "DontZap" "true"
      '';
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      dpi = 120;
      windowManager.i3.enable = true;
      displayManager = {
        slim.enable = true;
        slim.defaultUser = "legogris";
        # sessionCommands = ''
        #   gpg-connect-agent /bye
        #   GPG_TTY=$(tty)
        #   export GPG_TTY
        # '';
      };

      libinput.enable = true; # Touchpad support
    };
    strongswan = {
      enable = true;
      secrets = [ "/home/legogris/.config/libreswan/ipsec.secrets" ];
      connections = {
        "%default" = {
          keyexchange = "ikev2";
          authby = "secret";
          auto = "route";
        };
        kaikoEuWest3 = {
          right = "52.47.92.213";
          rightsubnet = "172.31.0.0/16";
          leftsourceip = "%config";
          rightid = "vpn@kaiko.aws";
          leftid = "robert@kaiko.aws";
        };
      };
    };
    #libreswan = {
    #  enable = true;
    #  configSetup = ''
    #        secretsfile=/home/legogris/.config/libreswan/ipsec.secrets
    #        protostack=netkey
    #        nat_traversal=yes
    #        virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
    #    '';
    #  connections = {
    #    kaikoEuWest3 = ''
    #keyexchange=ike
    #left=%defaultroute
    ## leftid=vpn@kaiko.aws
    #rightid=robert@kaiko.aws
    #right=52.47.92.213
    #auto=add
    #authby=secret
    ## rightsourceip=10.0.0.0/20
    ## rightid=robert@kaiko.aws
    #rightsubnet=172.31.0.0/16
    #  '';
    #  };
    #};
    borgbackup = {
      jobs = {
        rootBackup = {
          paths = "/";
          exclude = [ "/nix" "/tmp" "/mnt" "/proc" "/sys"  "/dev" "/run" ];
          repo = "rsync_net:backup-strength";
          archiveBaseName = "strength-root";
          startAt = "daily";
          encryption = {
            mode = "repokey";
            passCommand = "pass show borg/strength_repo";
          };
          compression = "auto,zstd";
          prune.keep = {
            within = "1d"; # Keep all archives from the last day
            daily = 7;
            weekly = 4;
            monthly = -1;  # Keep at least one archive for each month
          };
        };
      };
    };

    # redshift = {
    #   enable = true;
    # }
    # openssh.enable = true;
    # printing.enable = true;
    gnome3.gnome-keyring.enable = true;
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 225 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -A 10"; }
        { keys = [ 224 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -U 10"; }
        { keys = [ 38 ]; events = [ "key" ];  command = "/run/wrappers/bin/slock"; }
        # { keys = [ 38 125 ]; events = [ "key" ];  command = "slock"; }
        # { keys = [ 38 125 ]; events = [ "key" ]; attributes = [ "grabbed" ]; command = "slock"; }
        # { keys = [ 133 46 ]; events = [ "key" ]; attributes = [ "grabbed" ]; command = "slock"; }
      ];
    };
    openvpn.servers = {
      kaikoVPN  = { config = '' config /home/legogris/.config/openvpn/kaiko-us-east-1.ovpn ''; };
    };
  };
  virtualisation.docker.enable = true;


  systemd.user.services.dunst = {
    enable = false;
    description = "Lightweight and customizable notification daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.dunst ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.dunst}/bin/dunst";
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    zsh = {
      enable = true;
      promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
      interactiveShellInit = ''
export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

# ZSH_THEME="ys"
plugins=(git man)

export EDITOR='vim'
alias tmux='tmux -2'
alias ll='ls -lahF'
#alias bell='echo -e "\a"'
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
REPORTTIME=15
setopt incappendhistory autocd extendedglob sharehistory extendedhistory HIST_REDUCE_BLANKS
unsetopt beep nomatch notify
source $ZSH/oh-my-zsh.sh
source ~/.config/zsh.prompt
[[ -z "$TMUX" ]] && exec tmux -2
'';
    };
    bash.enableCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    light.enable = true;
    slock.enable = true;
    # mtr.enable = true;
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      extraConfig = "
        [General]
        Enable=Source,Sink,Media,Socket
      ";
    };
  };

  users.extraUsers.legogris = {
    extraGroups = [
      "wheel" "disk" "audio" "video" "docker"
    ];
    createHome = true;
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
